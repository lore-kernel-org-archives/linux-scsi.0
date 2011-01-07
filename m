From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: target: problems with Persistent reservations, iscsi
Date: Fri, 07 Jan 2011 11:52:08 -0800
Message-ID: <1294429928.2895.126.camel@haakon2.linux-iscsi.org>
References: <a17263ef-dd96-468e-ad85-0f987cdacb4f@j25g2000yqa.googlegroups.com>
	 <1294184625.29002.29.camel@haakon2.linux-iscsi.org>
	 <20110105162720.GA4494@omega17.zumbi.com.ar>
	 <1294272793.14650.172.camel@haakon2.linux-iscsi.org>
	 <AANLkTik-A3sGw6t8b8pj9Q0vMoycTTiZiine-DK=pahZ@mail.gmail.com>
	 <1294351583.2895.87.camel@haakon2.linux-iscsi.org>
	 <1294354313.2895.93.camel@haakon2.linux-iscsi.org>
	 <AANLkTi=FfUEfsuZCvYhMvBjQfp=G0N0Q3vS8F9hZ2AN=@mail.gmail.com>
	 <1294427414.2895.120.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:40531 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab1AGT6I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jan 2011 14:58:08 -0500
In-Reply-To: <1294427414.2895.120.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gustavo Panizzo <gfaraway@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>

On Fri, 2011-01-07 at 11:10 -0800, Nicholas A. Bellinger wrote:
> On Fri, 2011-01-07 at 15:14 -0300, Gustavo Panizzo wrote:
> > Hi Nicholas,
> > 
> > that issue was fixed with your patch. thanks
> > i've found another issue
> > 
> > i've attached the dmesg from lio node, it keeps saying
> > 
> > SPC-3 PR [iSCSI] waiting for pr_res_holders
> > 
> > and the machine hangs
> > 
> > 
> > log from the testing machine
> > 
> > Check to verify there are no reservations on disk /dev/sdf from node
> > cluster2  Passed
> > RegisterIgnoreKeys on disk /dev/sdf from node cluster1 ................. Passed
> > Verify registrations for disk /dev/sdf on node cluster1 ................ Passed
> > RegisterIgnoreKeys on disk /dev/sdf from node cluster1 ................. Passed
> > Verify registrations for disk /dev/sdf on node cluster1 ................ Passed
> > Clear PGR on node cluster1 ............................................. Failed
> > 
> > 
> > do you want a wireshark capture at this point?
> > 
> 
> Hi Gustavo,
> 
> Looking at the latest dmesg, I believe this new issue is specific to the
> 
> 'REGISTER_AND_IGNORE_EXISTING_KEY: Changed Reservation Key for ...'
> 
> scenario below with APTPL=0 within core_scsi3_emulate_pro_register():
> 
> [  269.532906] SPC-3 PR [iSCSI] Service Action: REGISTER_AND_IGNORE_EXISTING_KEY Initiator Node: iqn.1994-05.com.redhat.cluster1:7f3715a3da22,i,0x00023d010000
> [  269.547412] SPC-3 PR [iSCSI] registration on Target Port: iqn.2010.ar.com.zumbi:disk0,0x0001
> [  269.555871] SPC-3 PR [iSCSI] for SINGLE TCM Subsystem iblock Object Target Port(s)
> [  269.563978] SPC-3 PR [iSCSI] SA Res Key: 0x4b6579412d2d2d2d PRgeneration: 0x00000007  APTPL: 0
> [  269.573005] SPC-3 PR: Set APTPL Bit Deactivated for REGISTER
> [  269.990649] SPC-3 PR [iSCSI] REGISTER_AND_IGNORE_EXISTING_KEY: Changed Reservation Key for iqn.1994-05.com.redhat.cluster1:7f3715a3da22 to: 0x4b6579422d2d2d2d PRgeneration: 0x00000008
> [  270.007747] SPC-3 PR: Set APTPL Bit Deactivated for REGISTER
> [  270.453160] SPC-3 PR [iSCSI] waiting for pr_res_holders
> [  270.460294] SPC-3 PR [iSCSI] waiting for pr_res_holders
> [  270.465543] SPC-3 PR [iSCSI] waiting for pr_res_holders
> [  270.471450] SPC-3 PR [iSCSI] waiting for pr_res_holders
> 
> It appears that we are missing the final call to core_scsi3_put_pr_reg() to
> drop pr_res_holders reference back to zero before returning.  Below is a quick
> patch to fix this specific case in core_scsi3_emulate_pro_register(), please
> re-test and I will try to reproduce and verify the fix on my end shortly.
> 

Hi again Gustavo,

I have been able to reproduce and verify the fix with the patch below.
This bugfix has been committed and pushed into lio-core-2.6.git/master
and lio-4.0 and sent out to linux-scsi for inclusion.

Thanks again for your bug report(s), and please let me know if you run
into any further issues against the Vertias PR logic.

--nab


> diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
> index 6b275bb..c858f20 100644
> --- a/drivers/target/target_core_pr.c
> +++ b/drivers/target/target_core_pr.c
> @@ -2327,6 +2327,7 @@ static int core_scsi3_emulate_pro_register(
>                         if (!(aptpl)) {
>                                 pr_tmpl->pr_aptpl_active = 0;
>                                 core_scsi3_update_and_write_aptpl(dev, NULL, 0);
> +                               core_scsi3_put_pr_reg(pr_reg);
>                                 printk("SPC-3 PR: Set APTPL Bit Deactivated"
>                                                 " for REGISTER\n");
>                                 return 0;
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

