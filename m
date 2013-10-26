From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH v2 0/10] IB SRP initiator patches for kernel 3.13
Date: Sat, 26 Oct 2013 14:29:32 +0200
Message-ID: <526BB5AC.7010601@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jack Wang <xjtuwjp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

The purpose of this InfiniBand SRP initiator patch series is as follows:
- Make the SRP initiator driver better suited for use in a H.A. setup.
  Add fast_io_fail_tmo, dev_loss_tmo and reconnect_delay parameters.
  With the default values of these parameters failover happens
  significantly faster. The dev_loss mechanism can be disabled which
  makes it possible to avoid device removal which is necessary when
  e.g. using initiator side mirroring.
- Improve performance by making the queue size configurable.
- Make it possible to figure out which SCSI host corresponds to which
  SRP initiator port by making the SGID (source GID) available in sysfs.

The changes since the previous version of this patch series are as follows
(see also http://thread.gmane.org/gmane.linux.drivers.rdma/17693):
- Renamed the "can_queue" parameter into "queue_size".
- Corrected the title of the introductory e-mail - changed kernel version
  "3.12" into "3.13".
- Corrected the description of /sys/class/srp_remote_ports/port-<h>:<n>/state.
- Corrected sysfs kernel version and date for the newly introduced sysfs
  attributes.
- Fixed a hard to trigger race condition that could be triggered only with
  identical values of reconnect_delay and fast_io_fail_tmo and that could
  cause failback not to occur (see also rport_fast_io_fail_timedout()). Note:
  I don't think it's useful for anyone to set reconnect_delay identical to
  fast_io_fail_tmo.

The individual patches in this series are:
0001-IB-srp-Make-transport-layer-retry-count-configurable.patch
0002-IB-srp-Keep-rport-as-long-as-the-IB-transport-layer.patch
0003-scsi_transport_srp-Add-transport-layer-error-handlin.patch
0004-IB-srp-Use-SRP-transport-layer-error-recovery.patch
0005-IB-srp-Start-timers-if-a-transport-layer-error-occur.patch
0006-scsi_transport_srp-Add-periodic-reconnect-support.patch
0007-IB-srp-Add-periodic-reconnect-functionality.patch
0008-IB-srp-Export-sgid-to-sysfs.patch
0009-IB-srp-Introduce-srp_alloc_req_data.patch
0010-IB-srp-Make-queue-size-configurable.patch

The full diff compared with the previous version is as follows:
diff --git a/Documentation/ABI/stable/sysfs-driver-ib_srp b/Documentation/ABI/stable/sysfs-driver-ib_srp
index ab8efd5..b9688de 100644
--- a/Documentation/ABI/stable/sysfs-driver-ib_srp
+++ b/Documentation/ABI/stable/sysfs-driver-ib_srp
@@ -63,6 +63,10 @@ Description:	Interface for making ib_srp connect to a new target.
 		  over multiple CPU's.
 		* tl_retry_count, a number in the range 2..7 specifying the
 		  IB RC retry count.
+		* queue_size, the maximum number of commands that the
+		  initiator is allowed to queue per SCSI host. The default
+		  value for this parameter is 62. The lowest supported value
+		  is 2.
 
 What:		/sys/class/infiniband_srp/srp-<hca>-<port_number>/ibdev
 Date:		January 2, 2006
@@ -156,8 +160,8 @@ Description:	InfiniBand service ID used for establishing communication with
 		the SRP	target.
 
 What:		/sys/class/scsi_host/host<n>/sgid
-Date:		December 1, 2013
-KernelVersion:	3.12
+Date:		February 1, 2014
+KernelVersion:	3.13
 Contact:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 Description:	InfiniBand GID of the source port used for communication with
 		the SRP target.
diff --git a/Documentation/ABI/stable/sysfs-transport-srp b/Documentation/ABI/stable/sysfs-transport-srp
index 21bd480..ec7af69 100644
--- a/Documentation/ABI/stable/sysfs-transport-srp
+++ b/Documentation/ABI/stable/sysfs-transport-srp
@@ -6,8 +6,8 @@ Description:	Instructs an SRP initiator to disconnect from a target and to
 		remove all LUNs imported from that target.
 
 What:		/sys/class/srp_remote_ports/port-<h>:<n>/dev_loss_tmo
-Date:		December 1, 2013
-KernelVersion:	3.12
+Date:		February 1, 2014
+KernelVersion:	3.13
 Contact:	linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 Description:	Number of seconds the SCSI layer will wait after a transport
 		layer error has been observed before removing a target port.
@@ -15,8 +15,8 @@ Description:	Number of seconds the SCSI layer will wait after a transport
 		will disable the dev_loss timer.
 
 What:		/sys/class/srp_remote_ports/port-<h>:<n>/fast_io_fail_tmo
-Date:		December 1, 2013
-KernelVersion:	3.12
+Date:		February 1, 2014
+KernelVersion:	3.13
 Contact:	linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 Description:	Number of seconds the SCSI layer will wait after a transport
 		layer error has been observed before failing I/O. Zero means
@@ -31,8 +31,8 @@ Description:	16-byte local SRP port identifier in hexadecimal format. An
 		example: 4c:49:4e:55:58:20:56:49:4f:00:00:00:00:00:00:00.
 
 What:		/sys/class/srp_remote_ports/port-<h>:<n>/reconnect_delay
-Date:		December 1, 2013
-KernelVersion:	3.12
+Date:		February 1, 2014
+KernelVersion:	3.13
 Contact:	linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 Description:	Number of seconds the SCSI layer will wait after a reconnect
 		attempt failed before retrying. Setting this attribute to
@@ -45,14 +45,14 @@ Contact:	linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 Description:	Role of the remote port. Either "SRP Initiator" or "SRP Target".
 
 What:		/sys/class/srp_remote_ports/port-<h>:<n>/state
-Date:		December 1, 2013
-KernelVersion:	3.12
+Date:		February 1, 2014
+KernelVersion:	3.13
 Contact:	linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 Description:	State of the transport layer used for communication with the
 		remote port. "running" if the transport layer is operational;
 		"blocked" if a transport layer error has been encountered but
-		the fail_io_fast_tmo timer has not yet fired; "fail-fast"
-		after the fail_io_fast_tmo timer has fired and before the
+		the fast_io_fail_tmo timer has not yet fired; "fail-fast"
+		after the fast_io_fail_tmo timer has fired and before the
 		"dev_loss_tmo" timer has fired; "lost" after the
 		"dev_loss_tmo" timer has fired and before the port is finally
 		removed.
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index e158f59..b4bd903 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2579,7 +2579,7 @@ enum {
 	SRP_OPT_SG_TABLESIZE	= 1 << 11,
 	SRP_OPT_COMP_VECTOR	= 1 << 12,
 	SRP_OPT_TL_RETRY_COUNT	= 1 << 13,
-	SRP_OPT_CAN_QUEUE	= 1 << 14,
+	SRP_OPT_QUEUE_SIZE	= 1 << 14,
 	SRP_OPT_USE_FAST_REG	= 1 << 15,
 	SRP_OPT_ALL		= (SRP_OPT_ID_EXT	|
 				   SRP_OPT_IOC_GUID	|
@@ -2603,7 +2603,7 @@ static const match_table_t srp_opt_tokens = {
 	{ SRP_OPT_SG_TABLESIZE,		"sg_tablesize=%u"	},
 	{ SRP_OPT_COMP_VECTOR,		"comp_vector=%u"	},
 	{ SRP_OPT_TL_RETRY_COUNT,	"tl_retry_count=%u"	},
-	{ SRP_OPT_CAN_QUEUE,		"can_queue=%d"		},
+	{ SRP_OPT_QUEUE_SIZE,		"queue_size=%d"		},
 	{ SRP_OPT_USE_FAST_REG,		"use_fast_reg=%d"	},
 	{ SRP_OPT_ERR,			NULL 			}
 };
@@ -2699,9 +2699,9 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
 			target->scsi_host->max_sectors = token;
 			break;
 
-		case SRP_OPT_CAN_QUEUE:
+		case SRP_OPT_QUEUE_SIZE:
 			if (match_int(args, &token) || token < 1) {
-				pr_warn("bad can_queue parameter '%s'\n", p);
+				pr_warn("bad queue_size parameter '%s'\n", p);
 				goto out;
 			}
 			target->scsi_host->can_queue = token;
@@ -2816,7 +2816,7 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
 
 	if (target->scsi_host->cmd_per_lun > target->scsi_host->can_queue
 	    && (opt_mask & SRP_OPT_MAX_CMD_PER_LUN))
-		pr_warn("cmd_per_lun = %d > can_queue = %d\n",
+		pr_warn("cmd_per_lun = %d > queue_size = %d\n",
 			target->scsi_host->cmd_per_lun,
 			target->scsi_host->can_queue);
 
diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index 8f66ed4..8b9cb22 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -423,7 +423,8 @@ static void rport_fast_io_fail_timedout(struct work_struct *work)
 		dev_name(&rport->dev), dev_name(&shost->shost_gendev));
 
 	mutex_lock(&rport->mutex);
-	__rport_fail_io_fast(rport);
+	if (rport->state == SRP_RPORT_BLOCKED)
+		__rport_fail_io_fast(rport);
 	mutex_unlock(&rport->mutex);
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
