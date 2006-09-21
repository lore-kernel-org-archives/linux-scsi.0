From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [RFC] [PATCH] qla4xxx driver resubmission
Date: Thu, 21 Sep 2006 09:46:47 -0400
Message-ID: <451297C7.4000007@emulex.com>
References: <1158710887.4358.17.camel@dcslnxpc.site>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:27846 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750831AbWIUNra
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Sep 2006 09:47:30 -0400
In-Reply-To: <1158710887.4358.17.camel@dcslnxpc.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David C Somayajulu <david.somayajulu@qlogic.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, Mike Christie <michaelc@cs.wisc.edu>, Doug Maxey <dwm@enoyolf.org>, David Wagner <david.wagner@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Duane Grigsby <duane.grigsby@qlogic.com>

Why does your LLD need to reach up into the block layer to find an i/o ?

Even if you are using tags as an index into something... I would think that
having to go up to the blk layer to retrieve a something that should have
already been known lower in the driver leaves room for race conditions.

-- james s

David C Somayajulu wrote:
> This is another resubmission of qla4xxx driver for QLogic Corporation's iSCSI HBAs.
> 
> The main changes from the previous submission are 
> - use block layer tagging
> - clean up code and remove unused function for firmware pass thru
> 
> Please not that this patch is dependant on the previously posted patch titled
> [RFC] [PATCH] helper function for retrieving scsi_cmd given host based block layer tag 
> ( http://marc.theaimsgroup.com/?l=linux-scsi&m=115871027627964&w=2 )
> 
> 
> The complete mega patch for the driver is at
> ftp://ftp.qlogic.com/outgoing/linux/iSCSI/upstream/5.00.05b10-k/0000-Initial-Commit-qla4xxx.txt
> 
> 
> For ease of comprehension the above patch has been broken down into 
> the following smaller patches: 
> (located at ftp://ftp.qlogic.com/outgoing/linux/iSCSI/upstream/5.00.05b10-k/ )
> 
> 0001-qla4xxx-driver-defs.diff
> 0002-qla4xxx-driver-init.diff
> 0003-qla4xxx-driver-os.diff
> 0004-qla4xxx-driver-isr.diff
> 0005-qla4xxx-driver-mbx.diff
> 0006-qla4xxx-driver-support.diff
> 0007-qla4xxx-driver-version.diff
> 
> All patches are against scsi-misc-2.6.git
> 
> Other items which needs to be done are 
>  - Add support for sysfs attributes. 
>  - Userspace support for session creation/deletion for iscsi HBAs. 
>  - Add support for other discovery modes ie iSNS/SLP. 
> 
> Here are the links to the previous two submissions
> http://marc.theaimsgroup.com/?l=linux-scsi&m=115532714515853&w=2
> 
> http://groups.google.com/group/open-iscsi/browse_frm/thread/536ce2edf9a60c48?hl=en
> 
> I believe block layer tagging was the gating item in the last submission. 
> I would really appreciate if it can be merged upstream.
> 
> Regards, 
> David Somayajulu 
> Qlogic Corporation. 
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
