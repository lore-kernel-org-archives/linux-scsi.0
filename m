From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 0/10] IB SRP initiator patches for kernel 3.12
Date: Thu, 10 Oct 2013 14:05:26 +0200
Message-ID: <52569806.9080201@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
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

The changes since the previous version of this patch series are as 
follows (see also http://thread.gmane.org/gmane.linux.drivers.rdma/17058/):
- Split the scsi_transport_srp changes in two patches to make review
   easier.
- Added a patch for exporting the SGID via sysfs.
- Included a few fixes for the rport state transition algorithm for
   issues discovered while testing this patch series on a larger setup
   (initiator with 4 IB ports and target with 8 IB ports or 32 SRP
   paths between initiator and target in total).

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
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
