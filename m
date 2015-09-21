From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 21/30] cxlflash: Fix to prevent workq from accessing freed memory
Date: Mon, 21 Sep 2015 17:44:40 -0500
Message-ID: <B29886C1-4FB9-4ED9-B7F1-0836F20008AC@linux.vnet.ibm.com>
References: <1442438635-49044-1-git-send-email-mrochs@linux.vnet.ibm.com> <1442439105-50148-1-git-send-email-mrochs@linux.vnet.ibm.com> <55FFF745.8080802@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:53938 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932434AbbIUWoo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Sep 2015 18:44:44 -0400
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Mon, 21 Sep 2015 16:44:43 -0600
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id E83CB19D803F
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2015 16:35:34 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8LMifBN11272240
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2015 15:44:41 -0700
Received: from d03av03.boulder.ibm.com (localhost [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8LMiekV024680
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2015 16:44:41 -0600
In-Reply-To: <55FFF745.8080802@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

> On Sep 21, 2015, at 7:25 AM, Tomas Henzl <thenzl@redhat.com> wrote:
> On 16.9.2015 23:31, Matthew R. Ochs wrote:
>> The workq can process work in parallel with a remove event, leading
>> to a condition where the workq handler can access freed memory.
>> 
>> To remedy, the workq should be terminated prior to freeing memory. Move
>> the termination call earlier in remove and use cancel_work_sync() instead
>> of flush_work() as there is not a need to process any scheduled work when
>> shutting down.
>> 
>> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
>> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
>> ---
>> drivers/scsi/cxlflash/main.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
>> index 1856a73..1625aea 100644
>> --- a/drivers/scsi/cxlflash/main.c
>> +++ b/drivers/scsi/cxlflash/main.c
>> @@ -736,12 +736,12 @@ static void cxlflash_remove(struct pci_dev *pdev)
>> 		scsi_remove_host(cfg->host);
>> 		/* Fall through */
>> 	case INIT_STATE_AFU:
>> +		cancel_work_sync(&cfg->work_q);
>> 		term_afu(cfg);
> 
> You disable irqs after a call to cancel_work_sync.
> That means a late int could trigger the workqueue again?
> Please disable irqs earlier - as described in Documentation/PCI/pci.txt

I'll change the order here such that the work is cancelled after
term_afu() is called.

-matt

