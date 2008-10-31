From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: [PATCH 0/2] FC pass through support - revised III
Date: Fri, 31 Oct 2008 08:34:19 -0700
Message-ID: <1EDC4F6D-F00A-48FC-BCBD-C3E4EAF66548@qlogic.com>
Mime-Version: 1.0 (Apple Message framework v929.2)
Content-Type: multipart/mixed; boundary=Apple-Mail-54-199439873
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:41022 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbYJaPeW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Oct 2008 11:34:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>, James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>, Robert W Love <robert.w.love@intel.com>


--Apple-Mail-54-199439873
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit

Here is the updated patch set that reflect all of feedbacks gathered  
so far.
Major features include,
- fc_service structure has defined
- request/reply structure have defined
- Timeout and abort mechanism are in place
- multi-SG support
- asynchronous nature of the service handling

Following are list of relevant email threads to the patch set.
http://marc.info/?l=linux-scsi&m=122123825918741&w=2
http://marc.info/?t=121908849700001&r=1&w=2
http://marc.info/?t=122105556800001&r=1&w=2

And here is a brief document about the feature.

--Apple-Mail-54-199439873
Content-Disposition: attachment;
	filename=fc_service_handling.txt
Content-Type: text/plain;
	x-unix-mode=0755;
	name="fc_service_handling.txt"
Content-Transfer-Encoding: 7bit

FC service support in the FC HBA driver

1. FC services
FC services refer to Fibre-Channel specific service requests that are for
use management, configuration, or test purposes. The Fibre-Channel speci-
fication defines various types of services for the clients - that is,
typically, the applications. When the client issues a service request, 
the server - that is, typically, a initiator, a switch, or a target -
will take the request and respond with appropriate data for the request.
As there are many different types of service requests are defined in the
FC specification, the requests are considered as opaque data by the agents
which are responsible to forward to the end device - block layer, FC
transport layer, LLD, etc.

Following are list of FC service types
- Link Services
	= Basic Link Services
	= Extended Link Services
- Generic Services
- Loopback

1.1. Link Services
Link Services provide architected functions available to users of the FC
ports.
Link Service frames are categorized as link data frames and follow the
flow control and response rules defined for device data frames (with the
exception of the ABTS).
They are subject to buffer-to-buffer and end-to-end credit as appropriate
for the class of service being used and may receive busy and reject
responses, as applicable.

1-1-1. BLS (Basic Link Service)
Basic Link Services provide a set of basic control functions that can be
used within the context of an existing Exchange to perform simple control
functions or pass control information between two ports involved in that
Exchange.
	- NOP
	- ABTS
	- RMC

1-1-2. ELS (Extended Link Service)
Extended Link Services provide a set of protocol-independent FC functions
that can be used by a port to perform a specified function or service at
another port.
Each ELS operation is performed using a separate Exchange. An ELS operation
normally consists of a Request (or Command) Sequence with a transfer of
Sequence Initiative and a Reply (or Response) Sequence that ends the
Exchange.
	- PLOGI
	- FLOGI
	- LOGO
	- ABTX
	- etc.

1-2. Generic Services

1-2-1. FC-CT
The FC-CT (Fibre Channel-Common Transport) protocol is used by applications
to communicate with various FC services (referred to as generic services).
The CT protocol is assigned protocol type '0x20' and observes all the
normal FC exchange and sequence management rules.
Node ports must perform N_Port login (PLOGI) with the generic service
provider before performing operations using the FC-CT protocol. As a general
rule, node ports should logout when they have completed operations with the
associated server to free up resources at both the client node port and
server node port.

1-3. Lookback
TBD

2. Infra-Structures
2-1. BSG
[NOTE} Following kernel configuration parameters need to be set
 Symbol: BLK_DEV_BSG [=y]
    Prompt: Block layer SG support v4 (EXPERIMENTAL)
      Defined at block/Kconfig:69
      Depends on: BLOCK && EXPERIMENTAL
      Location:
        -> Enable the block layer (BLOCK [=y])

2-2. FC transport layer

3. Implementation Details
3-1. FC transport layer changes
3-1.1. Initialization
As part of rport creation, fc_rport_create(), the FC transport layer
initializes/prepares request queue for each of rports created.
The fc_bsg_initialize() gets called from the fc_rport_create() for the
purpose. In the function, eventually, a request queue created, and
request_fn get set so that, in the case of requests come in, the
request handling can kicked in.
For the FC service handling, the FC transport layer has fc_service_dispatch()
function as the request_fn.

3-1-2. FC service handling
Once the application issues the FC service request through the BSG interface,
the request gets dequeued from the request queue and processed by the FC
transport layer and it gets passed down to the LLD.
For as a cookie, the FC transport layer allocates fc_service structure for
each of service requests. The cookie travels in between the FC transport
layer and the LLD during the processing.
To pass the fc_service structure to the LLD, the FC transport layer calls
execute_fc_service() function.
The fc_function_template defines the prototype of the execute_fc_service()
and it gets registered during the LLD initialization if it supports the
FC service handling.
The FC service request handled in asynchronously, which means that there is
a callback function defined in the FC transport layer and that is,
fc_service_done().
The LLD calls this callback when it gets the service request done.
 
3-1-2-1. Timeout
As part of error handling, the FC transport layer provide timer mechanism
for the FC service handling.
During the initialization, the FC transport layer set default timeout period
for the queue that it initializes. The default value is
BLK_DEFAULT_SG_TIMEOUT.
If the application specifies its own timeout value for the service request,
It will be honored by the block layer and added into timer_list with the
given value. Otherwise, the default value will be used.
The timer will be added to the list just before the block layer issues 
the service request to the FC transport layer.
The API blk_add_timer() is the one being used for this purpose.
When a certain request service gets timedout, registered timeout handler
will get called for further handling.

3-1-2-2. Abort
To abort a service request that is timed out, the FC transport layer
provides function prototpye of the abort handler for the LLD in the
fc_function_template structure.
Each LLD, when it gets loaded, should register a abort handler for this
purpose.

3-2. LLD changes
3-2-1. Initialization.
During the driver loading, the LLD registers two separate functions that get
called in part of FC service handling.
	.execute_fc_service
	.abort_fc_service
The execute_fc_service() is the actual function that processes the FC service
and pass it down to the end-port via the HBA.
The abort_fc_service is a handler for any FC service request that has time out
or failed to complete and stays in the LLD or the end-port side.

3-2-2. FC service handling
The LLD shall handles the service in asynchronously so that it must call the
callback, which defined in FC transport layer, once the LLD notified from the
end-port via the HBA for the service completion.

4. Definitionss & Structures

4-1. Definitions
/* Following structure defines frame service type. */
enum fc_frame_type {
	FC_FRAME_TYPE_BS,
	FC_FRAME_TYPE_ELS,
	FC_FRAME_TYPE_IEC = 4,
	FC_FRAME_TYPE_IP,
	FC_FRAME_TYPE_FCP = 8,
	FC_FRAME_TYPE_GPP,
	FC_FRAME_TYPE_FC_CT = 0x20,
};

/*
 * Following structure defines FC service completion. It specifies whether
 * the service has completed or not. However, it won't specify whether it
 * completed successfully or not. It will be indicated by fc_service_reply
 * structure.
 */
enum fc_service_status {
	FC_SERVICE_COMPLETE,
	FC_SERVICE_TIMEOUT,
	FC_SERVICE_ABORT,
	FC_SERVICE_UNSUPPORTED,
	FC_SERVICE_ERROR = -1,
};

/*
 * Following definitions define the FC service state and these state sits
 * in the service_state_flags entry once the service requested.
 */
#define FC_SERVICE_STATE_PENDING      1
#define FC_SERVICE_STATE_DONE         2
#define FC_SERVICE_STATE_ABORTED      4
#define FC_SERVICE_STATE_TIMEOUT      8

#define FC_SERVICE_TIMEOUT 10

/*
 * request (CDB) structure of the sg_io_v4
 * This structure specifies FC service type. As the actual FC service itself
 * considered as opaque data by the kernel modules (associated with the
 * operation) and by the HBA, this is a only structure that provides any
 * necessary information about the service.
 */
struct fc_service_request {
	u8   request_type;
	u8   timeout;
	u8   reserved0;
	u8   reserved1;
};

/*
 * resonse  (request sense data) structure of the sg_io_v4
 * This structure specifies detail status of the FC service completion.
 * There are two separate class of status values are exist.
 * the 'status' field specifies whether the service has completed or not.
 * the 'error_code/additional_error_code' specifies detail error condition
 * of the service completed, if any.
 * the 'residual' field specifies residual bytes, in case of the err_code
 * (or additional_error_code) relavents.
 */
struct fc_service_reply {
	enum fc_service_status status;
	u16  error_code;
	u16  additional_error_code;
	u32  residual;
};

struct fc_service {
	struct fc_rport  *rport;
	struct list_head list;

	spinlock_t   service_state_lock;
	unsigned     service_state_flag;

	struct request *req;
	struct request_queue *q;

	/* Used by the discovery code. */
	struct completion  completion;
	int  timeout;

	struct fc_service_request *srv_request;
	void  *payload;
	struct scatterlist *payload_dma;
	int   payload_sg_cnt;
	int   payload_size;
	void  *response;
	struct scatterlist *response_dma;
	int   response_sg_cnt;
	int   response_size;

	struct fc_service_reply srv_reply;
	void  *reply_seq;   /* pointer to sense area of request */
	void  (*service_done)(struct fc_service *);

	void *lld_pkt;
};


5. Application
To issue FC service requests to the devices, the application calls a couple
of system calls as below,
	- open()
	- ioctl(.., SG_IO, ..)
	- close()

Under the /dev directory, there will be device files with following convention for the devices.
# ls /dev/
rport-5:0-0  rport-5:0-1  rport-5:0-2

where, 
	rport-5:0-0
	      | | |
	      | | -- target #
	      | -- channel #
	      -- host #

Here is snippet of the actual application.

void
els_echo(int fd, char *dev)
{
	int i;
	char cdb[16];
	char request_sense[18];
	char response[64];
	struct sg_io_v4 sg_io;
	struct fc_els_frame els;
	int res;

	els.els_hdr.els_cmd = 0x10; /* ELS cmd - echo */
	els.els_hdr.els_param[2] = 0;
	els.els_hdr.els_param[1] = 0;
	els.els_hdr.els_param[0] = 0;

	els.els_srv_param[0] = 0xcafecafe;
	els.els_srv_param[1] = 0xc8c8c8c8;
	els.els_srv_param[2] = 0xdeaddead;
	els.els_srv_param[3] = 0xaceaceac;

	cdb[0] = 0x01; /* ELS type */

	sg_io.guard = 'Q';
	sg_io.protocol = BSG_PROTOCOL_SCSI;
	sg_io.subprotocol = BSG_SUB_PROTOCOL_SCSI_TRANSPORT;

	sg_io.request_len = sizeof(cdb);
	sg_io.request = (__u64) cdb;
	sg_io.dout_xfer_len = sizeof (struct fc_els_frame);
	sg_io.dout_xferp = (__u64) &els;

	sg_io.din_xfer_len = sizeof(struct fc_els_frame);

	sg_io.din_xferp = (__u64) response;
	sg_io.max_response_len = sizeof(request_sense);
	sg_io.response = (__u64) request_sense;

	sg_io.timeout = FC_SERVICE_TIMEOUT;

	memset(response, 0x0, sizeof (response));

	res = ioctl(fd, SG_IO, &sg_io);
	if (res < 0) {
		printf("ERROR: nothing could be written to %s, error = %d\n",
		    dev, res);
	}

	printf("result of IOCTL:\n");
	for (i=0;i<sizeof (response); i++) {
		printf("%2x ", response[i]);
		if ((i % 4) == 3)
			printf("\n");
	}
}

int
main(int argc, char **argv)
{
	int i;
	int fd;

	if (argc < 2) {
		printf("ERROR: specify rport (f.e. /dev/rport-6:0-0\n");
		return 1;
	}
	fd = open(argv[1], O_RDWR);
	if (fd < 0) {
		printf("ERROR: failed opening %s\n", argv[1]);
		return;
	}

	els_echo(fd, argv[1]);

	close(fd);
}

--Apple-Mail-54-199439873
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit




Please review and apply them.

[NOTE] The patch for qla2xxx module has created against on top of  
following
       submission, which is enqueued.
       http://marc.info/?t=122420587000004&r=1&w=2

Thank you,
Seokmann
--Apple-Mail-54-199439873--
