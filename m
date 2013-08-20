From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 0/8] IB SRP initiator patches for kernel 3.12
Date: Tue, 20 Aug 2013 14:41:14 +0200
Message-ID: <521363EA.8080906@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

The purpose of this InfiniBand SRP initiator patch series is as follows:
- Make the SRP initiator driver better suited for use in a H.A. setup.
   Add fast_io_fail_tmo, dev_loss_tmo and reconnect_delay parameters.
   These can be used either to speed up failover or to avoid device
   removal when e.g. using initiator side mirroring.
- Make the SRP initiator better suited for use on NUMA systems by
   making the HCA completion vector configurable.
- Improve performance by making the queue size configurable.

Changes since the previous patch series are:
- Rewrote the srp_tmo_valid() to improve readability (requested by Dave
   Dillow).
- The combination (reconnect_delay < 0 && fast_io_fail_tmo < 0 &&
   dev_loss_tmo < 0) is now rejected as requested by Dave Dillow.
- Fixed a race between transport layer failure handling and device
   removal. This issue was reported by Vu Pham.

The previous patch series can be found here:
http://thread.gmane.org/gmane.linux.drivers.rdma/16389

The individual patches in this series are:
0001-IB-srp-Keep-rport-as-long-as-the-IB-transport-layer.patch
0002-scsi_transport_srp-Add-transport-layer-error-handlin.patch
0003-IB-srp-Add-srp_terminate_io.patch
0004-IB-srp-Use-SRP-transport-layer-error-recovery.patch
0005-IB-srp-Start-timers-if-a-transport-layer-error-occur.patch
0006-IB-srp-Make-transport-layer-retry-count-configurable.patch
0007-IB-srp-Introduce-srp_alloc_req_data.patch
0008-IB-srp-Make-queue-size-configurable.patch
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
