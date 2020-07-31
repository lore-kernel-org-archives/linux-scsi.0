Return-Path: <SRS0=WBt/=BK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9E2DC433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 08:02:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A46E72250E
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 08:02:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="BytQfYyN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731800AbgGaICp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 31 Jul 2020 04:02:45 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:10654 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731479AbgGaICm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 31 Jul 2020 04:02:42 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1596182562; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=MKSQY5RVrXIwpdJw6RKFSgNCGEE7ar+hIe83C8B0HxA=;
 b=BytQfYyNy6LeUGbaHtFI/4GZMIum8cMvldKcm+E82GXM8hnokDjcgZB6B1NuJJqR4vAK/N9Q
 UZnb7d1XeqHiJJuVKCY6Bg+KOyn0/PtEUnV5oDuiEVsP6LHgMYqp5mFiAlRS0nqWf9jHaazg
 SxZJ26Gv/F6FNP7HhR2JHxOyukk=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n09.prod.us-east-1.postgun.com with SMTP id
 5f23cfa014acd1952be8fde8 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 31 Jul 2020 08:00:32
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id DF499C433A1; Fri, 31 Jul 2020 08:00:31 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 881C9C4339C;
        Fri, 31 Jul 2020 08:00:28 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 31 Jul 2020 16:00:28 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <Avri.Altman@wdc.com>, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, alim.akhtar@samsung.com,
        jejb@linux.ibm.com, beanhuo@micron.com, asutoshd@codeaurora.org,
        matthias.bgg@gmail.com, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com,
        chaotian.jing@mediatek.com, cc.chou@mediatek.com
Subject: Re: [PATCH v4] scsi: ufs: Cleanup completed request without interrupt
 notification
In-Reply-To: <97f1dfb0-41b6-0249-3e82-cae480b0efb6@acm.org>
References: <20200724140246.19434-1-stanley.chu@mediatek.com>
 <SN6PR04MB4640B5FC06968244DDACB8BEFC720@SN6PR04MB4640.namprd04.prod.outlook.com>
 <1596159018.17247.53.camel@mtkswgap22>
 <97f1dfb0-41b6-0249-3e82-cae480b0efb6@acm.org>
Message-ID: <8b0a158a7c3ee2165e09290996521ffc@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On 2020-07-31 12:06, Bart Van Assche wrote:
> On 2020-07-30 18:30, Stanley Chu wrote:
>> On Mon, 2020-07-27 at 11:18 +0000, Avri Altman wrote:
>>> Looks good to me.
>>> But better wait and see if Bart have any further reservations.
>> 
>> Would you have any further suggestions?
> 
> Today is the first time that I took a look at ufshcd_abort(). The
> approach of that function looks wrong to me. This is how I think that a
> SCSI LLD abort handler should work:
> (1) Serialize against the completion path
> (__ufshcd_transfer_req_compl()) such that it cannot happen that the
> abort handler and the regular completion path both call
> cmd->scsi_done(cmd) at the same time. I'm not sure whether an existing
> synchronization object can be used for this purpose or whether a new
> synchronization object has to be introduced to serialize scsi_done()
> calls from __ufshcd_transfer_req_compl() and ufshcd_abort().
> (2) While holding that synchronization object, check whether the SCSI
> command is still outstanding. If so, submit a SCSI abort TMR to the 
> device.
> (3) If the command has been aborted, call scsi_done() and return
> SUCCESS. If aborting failed and the command is still in progress, 
> return
> FAILED.
> 
> An example is available in srp_abort() in
> drivers/infiniband/ulp/srp/ib_srp.c.
> 
> Bart.


AFAIK, sychronization of scsi_done is not a problem here, because scsi 
layer
use the atomic state, namely SCMD_STATE_COMPLETE, of a scsi cmd to 
prevent
the concurrency of abort and real completion of it.

Check func scsi_times_out(), hope it helps.

enum blk_eh_timer_return scsi_times_out(struct request *req)
{
...
         if (rtn == BLK_EH_DONE) {
                 /*
                  * Set the command to complete first in order to prevent 
a real
                  * completion from releasing the command while error 
handling
                  * is using it. If the command was already completed, 
then the
                  * lower level driver beat the timeout handler, and it 
is safe
                  * to return without escalating error recovery.
                  *
                  * If timeout handling lost the race to a real 
completion, the
                  * block layer may ignore that due to a fake timeout 
injection,
                  * so return RESET_TIMER to allow error handling another 
shot
                  * at this command.
                  */
                 if (test_and_set_bit(SCMD_STATE_COMPLETE, &scmd->state))
                         return BLK_EH_RESET_TIMER;
                 if (scsi_abort_command(scmd) != SUCCESS) {
                         set_host_byte(scmd, DID_TIME_OUT);
                         scsi_eh_scmd_add(scmd);
                 }
         }
}

Thanks,

Can Guo.
