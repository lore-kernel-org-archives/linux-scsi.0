From: Douglas Gilbert <dougg@torque.net>
Subject: sg_v4 interface, release 1.3
Date: Wed, 04 Apr 2007 17:00:29 -0400
Message-ID: <461411ED.5060300@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020805070109010501020104"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:51525 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbXDDVDh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Apr 2007 17:03:37 -0400
Received: from ip-229.82.126.206.dsl-cust.ca.inter.net ([206.126.82.229] helo=[192.168.48.87])
	by pentafluge.infradead.org with esmtpsa (Exim 4.63 #1 (Red Hat Linux))
	id 1HZCdj-0000Sc-Ub
	for linux-scsi@vger.kernel.org; Wed, 04 Apr 2007 22:03:36 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------020805070109010501020104
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Attached is the SCSI generic version 4 interface, release
1.3

ChangeLog for release 1.3 [20070404]
  - increase tag size to 64 bits to comply with SAM-4 and SRP
  - add request_extra and spare_out2 for alignment

Doug Gilbert



--------------020805070109010501020104
Content-Type: text/plain;
 name="sg4_proposal.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sg4_proposal.txt"

                      SCSI Generic version 4 interface structure
                      ==========================================
                                                      Release 1.3

Goals:
  - handle both generalized request/response and data_out/data_in
    independently in same invocation (i.e. synchronous usage).
  - alternatively the request and data_out could be instigated in one
    invocation with pointers given for the incoming response and data_in.
    Then a second invocation (as a result of polling or asynchronous
    notification) reports the response and/or data_in is done, plus
    provides error/resid/timing information. This is asynchronous usage.
    This allows for the most complicated SCSI commands: tagged, variable
    length cdbs with bidirectional data transfers.
  - support multiple protocols. If they are generalized request-response
    protocols then they can choose either the request/response part of the
    interface or the data_out/data_in part.
  - layered error/condition reporting: (OS) driver, transport and device
    (logical unit). Method used to present this struct to OS (e.g. ioctl())
    may also report error (e.g. EPERM).
  - allow for auxiliary information to be passed back for the application
    client to consider
  - same structure can be used for a synchronous (e.g. interruptible ioctl)
    or asynchronous (e.g. ioctl()/read() ) pass through.
  - leave device (lu) or target addressing issues to some other mechanism
    (what SCSI standards call the I_T_L or the I_T nexus respectively) as
    they are transport dependent. However do include the tag level (the
    "_Q" part of a I_T_L_Q nexus).
  - stay close enough to struct sg_io_hdr (sg version 3 interface) to use
    with existing SG_IO ioctls, current implementations expect 'S' in
    'guard'


Comments:
  - unsigned 64 bit integers used as pointer carriers to ease 32/64
    bit code interworking (e.g. 32 bit app on 64 bit kernel)
  - should there be more (or less) spare fields?
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



ChangeLog for release 1.3 [20070404]
  - increase tag size to 64 bits to comply with SAM-4 and SRP
  - add request_extra and spare_out2 for alignment

ChangeLog for release 1.2 [20070314]
  - add dout_resid
  - re-arrange uint64_t types (i.e. pointer carriers) to be on a
    8 byte boundary
  - reinstate dout_iovec_count and din_iovec_count (they were in
    release 1.1 but bsg dropped them)
  - change name: response_len_wr to response_len
  - pick up some descriptions from bsg

ChangeLog for release 1.1 [20061106]
  - was called sg version 4 interface, version 1.1
    so change the second "version" to "release"


-------------------------------------------------------------------
#include <stdint.h>


struct sg_io_v4
{
        int32_t guard;          /* [i] 'Q' to differentiate from v3 */
        uint32_t protocol;      /* [i] 0 -> SCSI , .... */
        uint32_t subprotocol;   /* [i] 0 -> SCSI command, 1 -> SCSI task
                                   management function, .... */

        uint32_t request_len;   /* [i] in bytes {SCSI: cdb length} */
        uint64_t request;       /* [i], [*i] {SCSI: cdb} */
        uint64_t request_tag;   /* [i] {SCSI: task tag (only if flagged)} */
        uint32_t request_attr;  /* [i] {SCSI: task attribute} */
        uint32_t request_priority; /* [i] {SCSI: task priority} */
        uint32_t request_extra; /* [i] {spare, for padding} */
        uint32_t max_response_len; /* [i] in bytes */
        uint64_t response;      /* [i], [*o]  {SCSI: (auto)sense data} */

        /* "dout_": data out (to device); "din_": data in (from device) */
        uint32_t dout_iovec_count;      /* [i] 0 -> "flat" dout transfer */
                                /* else dout_xfer points to array of iovec */
        uint32_t dout_xfer_len; /* [i] bytes to be transferred to device */
        uint32_t din_iovec_count;       /* [i] 0 -> "flat" din transfer */
        uint32_t din_xfer_len;  /* [i] bytes to be transferred from device */
        uint64_t dout_xfer;     /* [i], [*i]  */
        uint64_t din_xfer;      /* [i], [*o]  */

        uint32_t timeout;       /* [i] units: milliseconds */
        uint32_t flags;         /* [i] additional control: bit mask */
        uint64_t usr_ptr;       /* [i->o] unused internally */
        uint32_t spare_in;      /* [i] */

        uint32_t driver_status; /* [o] 0 -> ok */
        uint32_t transport_status;      /* [o] 0 -> ok */
        uint32_t device_status; /* [o] {SCSI: command completion status} */
        uint32_t retry_delay;   /* [o] {SCSI: status+, units: 100 ms} */
        uint32_t info;          /* [o] additional information, bit mask */
        uint32_t duration;      /* [o] time to complete, in milliseconds */
        uint32_t response_len;  /* [o] bytes of response actually written */
        int32_t din_resid;      /* [o] actual_din_xfer_len - din_xfer_len */
        int32_t dout_resid;     /* [o] actual_dout_xfer_len - dout_xfer_len */
        uint64_t generated_tag; /* [o] {SCSI: transport generated task tag} */
        uint32_t spare_out;     /* [o] */
        uint32_t spare_out2;    /* [o] */

        /* uint32_t padding[1];   */

};

/* sizeof(sg_io_v4)=160 [divisible by 8 (and 16)] */


-------------------------------------------------------------------------

Doug Gilbert
4th April 2007

--------------020805070109010501020104--
