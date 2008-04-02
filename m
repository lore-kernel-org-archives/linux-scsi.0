From: "Love, Robert W" <robert.w.love@intel.com>
Subject: Proposed libfc Interfaces
Date: Wed, 2 Apr 2008 16:23:08 -0700
Message-ID: <10A7D0016239E24092DEF05CCC582E43035BD86B@fmsmsx411.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28012 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756656AbYDBXXN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Apr 2008 19:23:13 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello everyone,

	Here is our Open-FCoE re-architecture plan. Our intent is to
follow James Smart's guidance by converting our SW stack into an assist
library for FC HBAs. By creating a library API and a transport template
we hope to allow FC LLDs the ability to pick and choose which parts of
the library they wish to use. Our goal is to get this library to a point
where both fcoe and at least on other HBA are using some shared libfc
code. Later, I hope that all FC HBAs would use as much of this library
as possible. If you maintain a FC HBA please consider how feasible it
would be for your driver to use these APIs.

	We have a diagram we've been using to try and illustrate the
"modules" that a LLD could use. It's available here:
http://open-fcoe.org/openfc/images/open-fcoe_layers_overview.jpeg.
Certainly the FCoE LLD will use the entire library where other LLDs are
more likely to use just the LP/RP "modules".

	The following is a list of things we feel we need to do to make
the interfaces work as we've defined them as well as some
questions/talking points. Following this list is our interface
definitions.

1) Local Port (LP)

	The LP module will implement and use a fc_lport data structure.
It will contain the local port state, a pointer to the
fc_transport_template, a pointer to one or more exchange managers (EMs),
the negotiated FLOGI service parameters and an event list. The fc_lport
object will be allocated by the LLD.

	The Scsi_Host.hostdata will have two sections of private data.
The first will be the fc_lport object and the second will be any LLD
specific private data for that LP.

2) Events

	Events will be used to notify the LP that the fc_rport is READY.
We'll use notification chains for this. This means that whoever
implements the RP state machine will need to send an event to the
LP/Discovery module when it's successfully logged into a N_Port (i.e.
the Name Server (NS) N_Port or just a SCSI-FCP capable N_Port).
 
3) Remote Port (RP) & Local Port (LP) Interaction

	The LP state machine will reach a point where it needs to login
to the NS or where it needs to login to a FCP capable N_Port in the
fabric. In both of these cases the LP module will call rport_login()
which will be a transition point between the LP and RP modules. When
PLOGI/PRLI/RTV has completed the RP will send an event to the LP
notifying it that the RP is READY. It will be the LP's job to look at
its state and the event to determine what to do next. 

4) Obtaining fc_rport Objects

	The scsi_transport_fc layer currently maintains a list of
fc_rport objects per Scsi_Host. So, to access these objects we'll add
some functions to scsi_transport_fc to,
	
	* Find a fc_rport object by ID, WWNN or WWPN
	* Find all fc_rport objects associated with the Scsi_Host/LP
(for teardown)

	We believe that this will alleviate libfc from maintaining the
fc_lport to fc_rport association.

5) libfc Abstraction

	libfc will only know about fc_lport. fc_vports and any objects
corresponding to physical port instances will be left for the LLD to
manage.

6) fc_frame and sk_buffs

	The fc_frame will correspond to a skb_buff, but libfc should be
unaware of this, it will only deal with fc_frame objects. When the FCoE
LLD initializes a fc_frame it will be maintained in skb->cb.

7) FCoE MAC Snooping

	The LP module will set a flogi_progress flag, which will be a
member of the fc_lport structure. This will allow the LLD to know when
FLOGI is in in progress and that it should be snooping for the FCoE MAC
address.

8) Scsi_Host vs. fc_lport

	Currently all of our APIs pass around pointers to fc_lport
objects. We're worried that a LLD who is only using the LP state machine
may not necessarily care about fc_lport objects. Should we be passing
around Scsi_Host pointers and then having each libfc function access the
fc_lport from the private data?

9) Discovery Done Notification

	We have defined a targ_disc_done function pointer in the
fc_transport_template which will be called so that the LLD will be
notified when discovery is done. Is this something that the LLDs would
even use? We don't think that the FCoE LLD would need to know this.

10) fc_init()

	This may or may not be apparent so we'd like to call it out. The
fc_lport will be passed into this function along with its
fc_transport_template pointer. Libfc will populate any fields not
already satisfied by the LLD. We removed some functions from the libfc
API because they'd be filled in by libfc in fc_init() and would never be
called directly from the LLD. 


	We look forward to any/all feedback,

Vasu and Rob
------------------------------------------------------------------------
----

struct fc_transport_template {

	/**
	 * Mandatory Fields
	 *
	 * These handlers must be implemented by the LLD.
	 */

        /*
	 * Interface to send a FC frame
	 */
	int (*frame_send)(struct fc_lport *lp, struct  *fp);

	/*
	 * Allocate a new exchange and sequence pair.
	 */
	struct fc_seq *(*seq_get)(struct fc_lport *lp, struct fc_frame
				  *fp);

	/**
	 * Optional Fields
	 *
	 * The LLD may choose to implement any of the following
handlers.
	 * If LLD doesn't specify hander and leaves its pointer NULL
then
	 * the default libfc function will be used for that handler.
	 */

	/*
	 * Send the FC frame payload using FC a sequence.
	 *
	 * The LLD will determine if it needs to allocate a new 
	 * exchange/sequence or if it can reuse the sequence object of 
	 * previously used exchange by looking at the frame header. This

	 * means that some of the header's fields must be filled before 
	 * calling seq_send(). Those mandatory fields are,
	 *
	 * - routing control 
	 * - destination ID 
	 * - FC header type
	 * - frame control 
	 * - data field control
	 * - parameter or relative offset
	 *
	 * If a frame is the first frame of exchange then the fc_frame's

	 * sequence pointer will be NULL. In this case the EM will
allocate a
	 * new exchange/sequence pair. If it is not the first frame the
EM
	 * will re-use the sequence pointed to by the passed in frame.
	 * 
	 * The response handler is set in this routine by passing the
resp() 
	 * function pointer. It will be set in the corresponding
exchange
	 * and can be called in two scenarios: if a timeout occurs or if
a 
	 * response frame is recieved for the exchange.
	 *
	 * The resp() callback handler gets called when an exchange
timeout 
	 * fires or an exchange response is received. The 'op' argument
to 
	 * the resp() callback will determine type of response. The 'op'

	 * variable follows this policy,
	 *
	 *  If op > 0, then op is a FC opcode, first byte in FC frame
payload
	 *  If op <= 0, then op is an error code (e.g. exchange timeout)
	 * 
	 * The timeout value (in msec) for an exchange is set using the 
	 * timer_msec argument. The timer is cancelled when it fires or
when 
	 * the exchange completes.
	 *
	 */
	int (*seq_send)(struct fc_lport *lp, struct fc_frame *fp,
			void (*resp)(struct fc_seq *,
				     struct fc_frame *fp, int op, void
*arg )
			void *resp_arg,	u_int timer_msec);
	
	/*
	 * Indicate that an exchange/sequence tuple is complete and the
memory 
	 * allocated for the related objects may be freed.
	 */
	void (*seq_exch_complete)(struct fc_seq *sp);

	/*
	 * Abort an exchange and sequence. Generally called because of a
	 * timeout or an abort from the upper layer.
	 */
	int (*seq_exch_abort)(const struct fc_seq *req_sp);

	/*
	 * Allocate a fc_frame.
	 */
	struct fc_frame *(*frame_alloc)(size_t len);

	/*
	 * Free the memory pointed to by the fc_frame pointer.
	 */
	void (*frame_free)(struct fc_frame *fp);

	/*
	 * Initiate the LP state machine. This handler will use
fc_host_attr 
	 * to store the FLOGI service parameters, so fc_host_attr must
be 
	 * initialized before calling this handler.
	 */
	int (*fabric_login)(struct fc_lport *lp);

	/*
	 * This is a generic interface for sending events to a
	 * local port. For example, when a remote port becomes READY
	 * an event will be sent to the local port. 
	 *
	 * The arg argument may contain information specific to the 
	 * event, such as a fc_rport pointer as would be the case in 
	 * the example above.
	 */
	int (*lp_event)(struct fc_lport *lp, enum fc_lp_event, u32
			arg);

	/*
	 * Initiate Fibre Channel target discovery. The RP state machine
	 * will be started for each discovered SCSI-FCP capable N_Port
	 * discovered in the fabric.
	 */
	int (*targ_disc)(struct fc_lport *lp, u_int fc4_type);
	       
	/*
	 * Notifys the LLD when FC discovery is done.
	 */
	void (*targ_disc_done)(struct fc_lport *lp);

	/*
	 * Initiates the RP state machine. It is called from the LP
module.
	 * This function will issue the following commands to the N_Port
	 * identified by the FC ID provided.
	 *
	 * - PLOGI
	 * - PRLI
	 * - RTV
	 */
	int (*rport_login)(struct fc_lport *lp, fc_fid_t id);

	/*
	 * Logs the specified local port out of a N_Port identified
	 * by the ID provided.
	 */
	int (*rport_logout)(struct fc_lport *lp, fc_fid_t id);
};


#ifndef _LIBFC_H_
#define _LIBFC_H_

/**
 * LOCAL PORT LAYER 
 *****************************/
/* 
 * Initialize libfc. Any fields in the fc_transport_template left NULL
 * when calling this function will be filled in by libfc functions so 
 * that all handlers are defined for the local port.
 */
int fc_init(struct fc_lport *lp);

/* 
 * Destroy the specified local port by finding and freeing all 
 * fc_rports associated with it and then by freeing the fc_lport
 * itself.
 */
int fc_lp_destroy(struct fc_lport *lp);

/*
 * Send a frame to a local port. The fc_exch_mgr pointer 
 * can be NULL for exchanges not originated by a fc_lport,
 * such as State Change Notifications (SCN).
 */
void fc_lp_recv(struct fc_lport *lp,
		struct fc_exch_mgr *mp, struct  *fp);

/*
 * Initiate Fibre Channel target discovery. rport_login() in the
 * fc_transport_template will be called for each SCSI-FCP capable
 * N_Port discovered in the fabric.
 */
int fc_targ_disc(struct fc_lport *lp, u_int fc4_type);


/**
 * EXCHANGE MANAGER LAYER 
 *****************************/
/*
 * Allocates an Exchange Manager (EM). The EM will use exchanges
 * from a pool of exchanges allocated in this routine. Exchange IDs 
 * as well as the number of EMs will be dictated by LLD. The LLD may 
 * choose to have one EM per CPU as well as having one recieve thread 
 * per CPU. This strategy would allow there to be one EM/recieve 
 * thread per CPU and would remove contention on the EMs.
 * 
 * The privsize argument may be specified to allocate objects to 
 * help the LLD manage the exchange ID allocation.
 */
struct fc_exch_mgr *fc_exch_mgr_alloc(enum fc_class class,
				      u32 exch_count
				      u32 privsize);

/*
 * Free an exchange manager.
 */
void fc_exch_mgr_free(struct fc_exch_mgr *mp);

/*
 * Allocate a new exchange and sequence pair.
 */
struct fc_seq *fc_seq_get(struct fc_exch_mgr *mp);

/*
 * Find an exchange and sequence pair by the provided exchange ID.
 */
struct fc_seq *fc_seq_find(struct fc_exch_mgr *mp, fc_xid_t ex_xid);


/**
 * SCSI LAYER 
 *****************************/
/*
 * This section provides an API which allows direct interaction
 * with the SCSI-ml. Each of these functions satisfies a function
 * pointer defined in Scsi_Host and therefore is always called 
 * directly from the SCSI-ml.
 */
int fc_queuecommand(struct scsi_cmnd *sc_cmd,
		    void (*done)(struct scsi_cmnd *));

/*
 * Send an ABTS frame to the target device. The sc_cmd argument
 * is a pointer to the SCSI command to be aborted.
 */
int fc_eh_abort(struct scsi_cmnd *sc_cmd);

/*
 * Reset a LUN by sending send the tm cmd to the target.
 */
int fc_eh_device_reset(struct scsi_cmnd *sc_cmd);

/*
 * Reset the host adapter.
 */
int fc_eh_host_reset(struct scsi_cmnd *sc_cmd);

/*
 * Create a os_lun object and set its state to READY.
 */
int fc_slave_alloc(struct scsi_device *sdev);

/*
 * Configure the queue depth for Tagged Command Queueing.
 */
void fc_slave_configure(struct scsi_device *sdev);

/*
 * Free the memory allocated for a os_lun object created 
 * by fc_slave_alloc().
 */
void fc_slave_destroy(struct scsi_device *sdev);

/*
 * Adjust the queue depth.
 */
int fc_change_queue_depth(struct scsi_device *sdev, int qdepth);

/*
 * Change the tag type.
 */
int fc_change_queue_type(struct scsi_device *sdev, int tag_type);

#endif /* _LIBFC_H_ */
