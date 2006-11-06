From: Douglas Gilbert <dougg@torque.net>
Subject: RFC: SCSI Generic version 4 interface
Date: Mon, 06 Nov 2006 16:47:30 -0500
Message-ID: <454FAD72.6040103@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020109010906090908050304"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:57829 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1752437AbWKFVrZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Nov 2006 16:47:25 -0500
Received: from ip-72.56.99.216.dsl-cust.ca.inter.net ([216.99.56.72] helo=[192.168.48.80])
	by pentafluge.infradead.org with esmtpsa (Exim 4.63 #1 (Red Hat Linux))
	id 1GhCJP-0005Lg-7G
	for linux-scsi@vger.kernel.org; Mon, 06 Nov 2006 21:47:23 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------020109010906090908050304
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

I was asked to put together a proposal in May this
year for a new SCSI Generic interface structure. This
is the same structure that is used by the block layer
SG_IO ioctl. A few people have asked whether I had forgotten
that I agreed to write the proposal. So here it is. Those
who have seen it have made comments, some of which have
been incorporated.

Some shortcomings of the sg version 3 interface are:
  - can't handle commands with bidirectional data (either
    can the SCSI subsystem at the moment)
  - if it was a bit more general it could carry other
    request/response protocols (e.g. Task Management
    Functions and SMP in Serial Attached SCSI)
  - no way of associating a task attribute or task tag
    with a SCSI command

Feel free to make suggestions.

Doug Gilbert


--------------020109010906090908050304
Content-Type: text/plain;
 name="sg4_proposal.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sg4_proposal.txt"

                SCSI Generic version 4 interface structure
                ==========================================
                                             Version 1.1

Goals:
  - handle both generalized request/response and data_out/data_in
    independently in same invocation. Alternatively the request
    and data_out could be in one invocation and the response and
    data_in in a following invocation. This allows for the most
    complicated SCSI commands: tagged variable length cdbs with
    bidirectional data transfers.
  - support multiple protocols. If they are generalized request-response
    protocols then they can choose either the request/response part
    of the interface or the data_out/data_in part.
  - layered error/condition reporting: (OS) driver, transport and
    device (logical unit). Method used to present this struct to OS
    (e.g. ioctl()) may also report error (e.g. EPERM).
  - allow for auxiliary information to be passed back for the
    application client to consider
  - same structure can be used for a synchronous (e.g. interruptible
    ioctl) or asynchronous (e.g. ioctl()/read() ) pass through.
  - leave device (lu) or target addressing issues to some other
    mechanism (what SCSI standards call the I_T_L or the I_T nexus
    respectively) as they are transport dependent. However do include
    the tag level (the "_Q" part of a I_T_L_Q nexus).
  - stay close enough to struct sg_io_hdr (sg version 3 interface)
    to use with existing SG_IO ioctls, current implementations
    expect 'S' in 'guard'


Comments:
  - use 64 bit integers to convey pointers. Does this help with
    32 to 64 bit thunking?
  - should there be more (or less) spare fields?
  - we could allow the "struct" to be rubbery, only requiring the
    first three integers and perhaps an additional_len field
  - the write() usage in the sg driver's asynchronous interface has
    caused problems when mistakenly applied to a block device node
    rather than a sg device node. Using an ioctl(flag_async) followed
    by a read() for asynchronous work offers similar functionality and
    is safer. Using ioctl(flag_async_start) and ioctl(flag_async_finish)
    is another possibility.
  - rather than have a separate ATA pass through mechanism, the SAT
    defined ATA PASS THROUGH SCSI commands could be used with the
    driver implementation routing the ATA commands to their
    subsystem. This could be flagged so it didn't preclude a SAT layer
    in a SCSI transport (e.g. MPT SAS HBA firmware).
  - if SAM/SPC does not define an enumeration for lesser used input
    fields, then use the value 0 for inert/off/don't_care .


-------------------------------------------------------------------


struct sg_io_v4
{
        int32_t guard;          // [i] 'Q' to differentiate from v3
        uint32_t protocol;      // [i] 0 -> SCSI , ....
        uint32_t subprotocol;   // [i] 0 -> SCSI command, 1 -> SCSI task
                                // management function, ....

        uint32_t request_len;   // [i] in bytes
        uint64_t request;       // [i], [*i] {SCSI: cdb}
        uint32_t request_attr;  // [i] {SCSI: task attribute}
        uint32_t request_tag;   // [i] {SCSI: task tag (only if flagged)}
        uint32_t request_priority; // [i] {SCSI: task priority}
        uint32_t max_response_len; // [i] in bytes
        uint64_t response;      // [i], [*o]  {SCSI: (auto)sense data}

        // "din_" for data in (from device); "dout_" for data out (to device)
        uint32_t dout_iovec_count;      // [i] 0 -> "flat" data transfer
                                // else dout_xfer points to array of iovec
        uint32_t dout_xfer_len; // [i] bytes to be transferred to device
        uint64_t dout_xfer;     // [i], [*i] 
        uint32_t din_iovec_count;       // [i]
        uint32_t din_xfer_len;  // [i] bytes to be transferred from device
        uint64_t din_xfer;      // [i], [*o] 

        uint32_t timeout;       // [i] units: seconds or milliseconds?
        uint32_t flags;         // [i] bit mask
        uint64_t usr_ptr;       // [i->o] unused internally
        uint32_t spare_in;      // [i]

        uint32_t driver_status; // [o] 0 -> ok
        uint32_t transport_status;      // [o] 0 -> ok
        uint32_t device_status; // [o] {SCSI: command completion status}
        uint32_t retry_delay;   // [o] {SCSI: status auxiliary information}
        uint32_t info;          // [o] additional information
        uint32_t duration;      // [o] time to complete, in milliseconds
        uint32_t response_len_wr;// [o] bytes of response actually written
        int32_t din_resid;      // [o] actual_din_xfer_len - din_xfer_len
        uint32_t generated_tag; // [o] {SCSI: task tag that transport chose}
        uint32_t spare_out;     // [o]

};


-------------------------------------------------------------------------

Doug Gilbert
6th November 2006

--------------020109010906090908050304--
