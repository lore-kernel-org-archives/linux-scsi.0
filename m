Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F15BC43461
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 06:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5D72207EA
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 06:18:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="jfVchnIo";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="g0LYY281"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbgIJGSg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Sep 2020 02:18:36 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47740 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727087AbgIJGSd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Sep 2020 02:18:33 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id EBB198EE111;
        Wed,  9 Sep 2020 23:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1599718711;
        bh=TJWhHlHzAlClXAXe2kCbpnsP6AOcRO12wDllzC1jL94=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jfVchnIo1va8JQ6RdB0Zk8SpluUw4Jfkr9t1hnZ/BygIXf3IrJzNNoQXcBr2AXC0S
         5S+4k86ud0bk5Ky7J0agRUH7XbnMEiXFZ5dtWcpNE9z919wcF5RjikKe1cHotcdqY9
         V7uzW84EllOOrJ9RPqenMF+rplVZzDciQxT0C34A=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id GddmNLu2bdxn; Wed,  9 Sep 2020 23:18:21 -0700 (PDT)
Received: from [153.66.254.174] (c-73-35-198-56.hsd1.wa.comcast.net [73.35.198.56])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 41C388EE064;
        Wed,  9 Sep 2020 23:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1599718699;
        bh=TJWhHlHzAlClXAXe2kCbpnsP6AOcRO12wDllzC1jL94=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=g0LYY281SY6fttyOIGqnGKf3jIRQNQE9obPZ3xhBMj6nC9sxgdtb8WSzrj0rY7HMb
         DeO/53DXDCeaTDkuilaGM+gyLVYQe8pimQv1ioowg9uMQQyqR6MVDZs47McjUTGmVU
         vnXkhhEdHAKeSgWjuOzeXA5WiIwO/Gz9FVLIQISU=
Message-ID: <1599718697.3851.3.camel@HansenPartnership.com>
Subject: Re: [PATCH v2 1/2] scsi: ufs: Abort tasks before clear them from
 doorbell
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        ziqichen@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Date:   Wed, 09 Sep 2020 23:18:17 -0700
In-Reply-To: <1599706080.10649.30.camel@mtkswgap22>
References: <1599099873-32579-1-git-send-email-cang@codeaurora.org>
         <1599099873-32579-2-git-send-email-cang@codeaurora.org>
         <1599627906.10803.65.camel@linux.ibm.com>
         <yq14ko62wn5.fsf@ca-mkp.ca.oracle.com>
         <1599706080.10649.30.camel@mtkswgap22>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-09-10 at 10:48 +0800, Stanley Chu wrote:
> Hi Martin, Can,
> 
> On Wed, 2020-09-09 at 22:32 -0400, Martin K. Petersen wrote:
> > Can and Stanley,
> > 
> > > I can't reconcile this hunk:
> > 
> > Please provide a resolution for these conflicting commits in fixes
> > and
> > queue:
> > 
> > 307348f6ab14 scsi: ufs: Abort tasks before clearing them from
> > doorbell
> > 
> > b10178ee7fa8 scsi: ufs: Clean up completed request without
> > interrupt
> > notification
> > 
> 
> Can's patch has considered my fix in the new flow.
> 
> To be more clear, for the fixing case in my patch,
> ufshcd_try_to_abort_task() will return 0 (err = 0) and finally the
> target tag can be completed and cleared by
> __ufshcd_transfer_req_compl()
> in Can's new flow.
> 
> Thus I think the resolution can just using the code in Can's patch.
> 
> Can, please correct me if I was wrong.

Well, that really doesn't make for an easy merge. The resolution I took
is below.

James

---

commit 5399a4aa684d491c35a386effe385c06b41398fa
Merge: 59958f7a956b 8c6572356646
Author: James Bottomley <James.Bottomley@HansenPartnership.com>
Date:   Wed Sep 9 23:12:52 2020 -0700

    Merge branch 'misc' into for-next
    
    Conflicts:
            drivers/scsi/ufs/ufshcd.c
            drivers/scsi/ufs/ufshcd.h

diff --cc drivers/scsi/ufs/ufshcd.c
index 34e1ab407b05,05716f62febe..49478c8a601f
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@@ -6574,84 -6739,22 +6736,25 @@@ static int ufshcd_abort(struct scsi_cmn
  	}
  	hba->req_abort_count++;
  
 -	/* Skip task abort in case previous aborts failed and report failure */
 -	if (lrbp->req_abort_skip) {
 -		err = -EIO;
 -		goto out;
 +	if (!(reg & (1 << tag))) {
 +		dev_err(hba->dev,
 +		"%s: cmd was completed, but without a notifying intr, tag = %d",
 +		__func__, tag);
 +		goto cleanup;
  	}
  
 -	err = ufshcd_try_to_abort_task(hba, tag);
 -	if (err)
 -		goto out;
 -
 -	spin_lock_irqsave(host->host_lock, flags);
 -	__ufshcd_transfer_req_compl(hba, (1UL << tag));
 -	spin_unlock_irqrestore(host->host_lock, flags);
 +	/* Skip task abort in case previous aborts failed and report failure */
- 	if (lrbp->req_abort_skip) {
++	if (lrbp->req_abort_skip)
 +		err = -EIO;
- 		goto out;
- 	}
- 
- 	for (poll_cnt = 100; poll_cnt; poll_cnt--) {
- 		err = ufshcd_issue_tm_cmd(hba, lrbp->lun, lrbp->task_tag,
- 				UFS_QUERY_TASK, &resp);
- 		if (!err && resp == UPIU_TASK_MANAGEMENT_FUNC_SUCCEEDED) {
- 			/* cmd pending in the device */
- 			dev_err(hba->dev, "%s: cmd pending in the device. tag = %d\n",
- 				__func__, tag);
- 			break;
- 		} else if (!err && resp == UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
- 			/*
- 			 * cmd not pending in the device, check if it is
- 			 * in transition.
- 			 */
- 			dev_err(hba->dev, "%s: cmd at tag %d not pending in the device.\n",
- 				__func__, tag);
- 			reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
- 			if (reg & (1 << tag)) {
- 				/* sleep for max. 200us to stabilize */
- 				usleep_range(100, 200);
- 				continue;
- 			}
- 			/* command completed already */
- 			dev_err(hba->dev, "%s: cmd at tag %d successfully cleared from DB.\n",
- 				__func__, tag);
- 			goto cleanup;
- 		} else {
- 			dev_err(hba->dev,
- 				"%s: no response from device. tag = %d, err %d\n",
- 				__func__, tag, err);
- 			if (!err)
- 				err = resp; /* service response error */
- 			goto out;
- 		}
- 	}
- 
- 	if (!poll_cnt) {
- 		err = -EBUSY;
- 		goto out;
- 	}
- 
- 	err = ufshcd_issue_tm_cmd(hba, lrbp->lun, lrbp->task_tag,
- 			UFS_ABORT_TASK, &resp);
- 	if (err || resp != UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
- 		if (!err) {
- 			err = resp; /* service response error */
- 			dev_err(hba->dev, "%s: issued. tag = %d, err %d\n",
- 				__func__, tag, err);
- 		}
- 		goto out;
- 	}
- 
- 	err = ufshcd_clear_cmd(hba, tag);
- 	if (err) {
- 		dev_err(hba->dev, "%s: Failed clearing cmd at tag %d, err %d\n",
- 			__func__, tag, err);
- 		goto out;
- 	}
++	else
++		err = ufshcd_try_to_abort_task(hba, tag);
  
 -out:
+ 	if (!err) {
 +cleanup:
- 	spin_lock_irqsave(host->host_lock, flags);
- 	__ufshcd_transfer_req_compl(hba, (1UL << tag));
- 	spin_unlock_irqrestore(host->host_lock, flags);
- 
++		spin_lock_irqsave(host->host_lock, flags);
++		__ufshcd_transfer_req_compl(hba, (1UL << tag));
++		spin_unlock_irqrestore(host->host_lock, flags);
 +out:
- 	if (!err) {
  		err = SUCCESS;
  	} else {
  		dev_err(hba->dev, "%s: failed with err %d\n", __func__, err);
diff --cc drivers/scsi/ufs/ufshcd.h
index b5b2761456fb,8011fdc89fb1..6663325ed8a0
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@@ -531,11 -531,10 +531,16 @@@ enum ufshcd_quirks 
  	 */
  	UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR		= 1 << 10,
  
 +	/*
 +	 * This quirk needs to be enabled if the host controller has
 +	 * auto-hibernate capability but it doesn't work.
 +	 */
 +	UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8		= 1 << 11,
++
+ 	/*
+ 	 * This quirk needs to disable manual flush for write booster
+ 	 */
 -	UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL		= 1 << 11,
++	UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL		= 1 << 12,
  };
  
  enum ufshcd_caps {
