From: "Kallickal, Jayamohan" <Jayamohan.Kallickal@Emulex.Com>
Subject: RE: [PATCH V2 15/18] be2iscsi: Fix the session cleanup when
 reboot/shutdown happens
Date: Fri, 12 Apr 2013 20:08:04 +0000
Message-ID: <8527c25b-b4d0-4902-ac6b-fdb71878e0d9@CMEXHTCAS2.ad.emulex.com>
References: <1365219519-3457-1-git-send-email-jayamohan.kallickal@emulex.com>
 <1365219519-3457-15-git-send-email-jayamohan.kallickal@emulex.com>
 <5165F8B6.8080506@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:35516 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578Ab3DLUIK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Apr 2013 16:08:10 -0400
In-Reply-To: <5165F8B6.8080506@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, Jayamohan Kallickal <jayamohank@gmail.com>
Cc: "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "John, Sony" <Sony.John-N@Emulex.Com>



-----Original Message-----
From: Mike Christie [mailto:michaelc@cs.wisc.edu] 
Sent: Wednesday, April 10, 2013 4:42 PM
To: Jayamohan Kallickal
Cc: jbottomley@parallels.com; linux-scsi@vger.kernel.org; Kallickal, Jayamohan; John, Sony
Subject: Re: [PATCH V2 15/18] be2iscsi: Fix the session cleanup when reboot/shutdown happens

On 4/5/13 10:38 PM, Jayamohan Kallickal wrote:
>   During reboot/shutdown cycle, the active sessions were not updated.
>   In iSCSI Boot case, the boot session was alive and this fix informs
>   that the machine is going down, so no more ops happens on that session.
>
> Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
> Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
> ---
>   drivers/scsi/be2iscsi/be_cmds.c |    2 +-
>   drivers/scsi/be2iscsi/be_cmds.h |    3 +++
>   drivers/scsi/be2iscsi/be_main.c |    1 +
>   3 files changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/be2iscsi/be_cmds.c 
> b/drivers/scsi/be2iscsi/be_cmds.c index e66aa7c..a3bfc1d 100644
> --- a/drivers/scsi/be2iscsi/be_cmds.c
> +++ b/drivers/scsi/be2iscsi/be_cmds.c
> @@ -340,7 +340,7 @@ static struct be_mcc_compl *be_mcc_compl_get(struct beiscsi_hba *phba)
>   	return NULL;
>   }
>
> -static void be2iscsi_fail_session(struct iscsi_cls_session 
> *cls_session)
> +void be2iscsi_fail_session(struct iscsi_cls_session *cls_session)
>   {
>   	iscsi_session_failure(cls_session->dd_data, ISCSI_ERR_CONN_FAILED);

I am not sure how this is working or what it fixes. During shutdown/reboot when the pci_driver shutdown callback is called, without the patch what is happening? Does the host shutdown cause iscsid to try and recover the session and that causes a shutdown/reboot hang?

I think you want to use ISCSI_ERR_INVALID_HOST. That would cause a clean shutdown of the sessions if iscsid is still up at that time. This would cause ep_disconnect to get called and a logout pdu to get sent.

ISCSI_ERR_CONN_FAILED just causes recovery to start (ep_disconnect will run if the ep is up and we will try to reconnect).

James,

I am looking into this issue raised by MikeC and would send a patch later to resolve this.

 So, I would like to withdraw this patch (15/18) now.

Thanks
Jay

