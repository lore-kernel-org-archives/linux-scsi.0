From: Maxim Kozover <maximkoz@netvision.net.il>
Subject: Re: Re: Re[8]: problems with scsi_transport_fc and qla2xxx
Date: Mon, 20 Mar 2006 13:45:59 +0300
Message-ID: <1375487327.20060320134559@netvision.net.il>
References: <1229893529.20060307000953@netvision.net.il>
 <20060306232831.GS6278@andrew-vasquezs-powerbook-g4-15.local>
 <1219491790.20060307124035@netvision.net.il>
 <20060307172227.GE6275@andrew-vasquezs-powerbook-g4-15.local>
 <1343850424.20060307231141@netvision.net.il>
 <20060308080050.GF9956@andrew-vasquezs-powerbook-g4-15.local>
 <20060308154341.GA1779@andrew-vasquezs-powerbook-g4-15.local>
 <1502511597.20060308213247@netvision.net.il>
 <20060310231344.GB641@andrew-vasquezs-powerbook-g4-15.local>
 <1699632492.20060312001014@netvision.net.il>
 <20060313231903.GK11755@andrew-vasquezs-powerbook-g4-15.local>
Reply-To: Maxim Kozover <maximkoz@netvision.net.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mxout5.netvision.net.il ([194.90.9.29]:56113 "EHLO
	mxout5.netvision.net.il") by vger.kernel.org with ESMTP
	id S1750782AbWCTLqA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Mar 2006 06:46:00 -0500
In-reply-to: <20060313231903.GK11755@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Michael Reed <mdr@sgi.com>, James.Smart@Emulex.Com

Hi Andrew!
Unfortunately I see that scan-work patch is not included in
2.6.16 and the usual lock appears:
#001:             [ffff8100708a8080] {scsi_host_alloc}
.. held by:         scsi_wq_4: 3912 [ffff810071edf870, 110]
... acquired at:               scsi_scan_target+0x51/0x87 [scsi_mod]

Applying the patch you sent solves the problem, i.e. disks appear again after
22 sec timeout (why?).

Thanks,

Maxim.

Tuesday, March 14, 2006, 2:19:03 AM, you wrote:

AV> diff --git a/drivers/scsi/scsi_transport_fc.c
AV> b/drivers/scsi/scsi_transport_fc.c
AV> index 929032e..3d09920 100644
AV> --- a/drivers/scsi/scsi_transport_fc.c
AV> +++ b/drivers/scsi/scsi_transport_fc.c
AV> @@ -1649,6 +1649,8 @@ fc_remote_port_delete(struct fc_rport  *
AV>                 return;
AV>         }
AV>  
AV> +       /* flush any scan work */ /* which can sleep */
AV> +       scsi_flush_work(rport_to_shost(rport));
AV>         scsi_target_block(&rport->dev);
AV>  
AV>         /* cap the length the devices can be blocked until they are deleted */


