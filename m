From: Willem Riede <wrlk@riede.org>
Subject: Re: Badness in scsi_single_lun_run at /root/scsi/scsi_lib.c:344
Date: Tue, 27 Jan 2004 22:30:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040128033041.GY23308@serve.riede.org>
References: <20040127003244.GM23308@serve.riede.org>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sccrmhc13.comcast.net ([204.127.202.64]:28925 "EHLO
	sccrmhc13.comcast.net") by vger.kernel.org with ESMTP
	id S265839AbUA1Dar (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jan 2004 22:30:47 -0500
Received: from serve.riede.org (localhost.localdomain [127.0.0.1])
	by serve.riede.org (8.12.10/8.12.10) with ESMTP id i0S3Uglu032521
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jan 2004 22:30:42 -0500
Content-Disposition: inline
In-Reply-To: <20040127003244.GM23308@serve.riede.org> (from wrlk@riede.org on Mon, Jan 26, 2004 at 19:32:44 -0500)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 2004.01.26 19:32, Willem Riede wrote:
> Jan 26 17:13:23 fallguy kernel: Badness in scsi_single_lun_run at /root/scsi/scsi_lib.c:344
> Jan 26 17:13:23 fallguy kernel: Call Trace:
> Jan 26 17:13:23 fallguy kernel:  [<e0850192>] scsi_single_lun_run+0x202/0x230 [scsi_mod]
> Jan 26 17:13:23 fallguy kernel:  [<e084a33d>] scsi_put_command+0xbd/0x160 [scsi_mod]
> Jan 26 17:13:23 fallguy kernel:  [<e0850347>] scsi_run_queue+0x187/0x190 [scsi_mod]
> Jan 26 17:13:23 fallguy kernel:  [<e0850524>] scsi_end_request+0xf4/0x150 [scsi_mod]
> Jan 26 17:13:23 fallguy kernel:  [<e08508f7>] scsi_io_completion+0x1c7/0x4b0 [scsi_mod]
> Jan 26 17:13:23 fallguy kernel:  [<e0829a32>] sd_rw_intr+0x82/0x260 [sd_mod]
> Jan 26 17:13:24 fallguy kernel:  [<e084aed1>] scsi_finish_command+0x81/0xe0 [scsi_mod]
> Jan 26 17:13:24 fallguy kernel:  [<e084ade8>] scsi_softirq+0xc8/0xf0 [scsi_mod]
> Jan 26 17:13:24 fallguy kernel:  [<c012d6a7>] do_softirq+0xc7/0xd0
> Jan 26 17:13:24 fallguy kernel:  [<c010e395>] do_IRQ+0x165/0x220

scsi_lib.c contains the following code:

                spin_lock(shost->host_lock);
                                                                                                                        
                if (!scsi_host_queue_ready(q, shost, sdev))
                        goto not_ready;
                if (sdev->single_lun) {
                        if (sdev->sdev_target->starget_sdev_user &&
                            sdev->sdev_target->starget_sdev_user != sdev)
                                goto not_ready;
                        sdev->sdev_target->starget_sdev_user = sdev;
                }
                shost->host_busy++;
                                                                                                                        
                /*
                 * XXX(hch): This is rather suboptimal, scsi_dispatch_cmd will
                 *              take the lock again.
                 */
                spin_unlock_irq(shost->host_lock);


Is it a problem that the lock is taken by means of spin_lock() and then
released with spin_unlock_irq() ? We do need to lock against scsi_softirq
as in the backtrace above...

Thanks, Willem Riede.
