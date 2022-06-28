Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D346C43334
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jun 2022 15:33:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345853AbiF1Pda (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jun 2022 11:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348321AbiF1PdG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jun 2022 11:33:06 -0400
Received: from bee.birch.relay.mailchannels.net (bee.birch.relay.mailchannels.net [23.83.209.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501B0DCF
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jun 2022 08:33:04 -0700 (PDT)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 50FBA1224C9;
        Tue, 28 Jun 2022 15:33:01 +0000 (UTC)
Received: from pdx1-sub0-mail-a228.dreamhost.com (unknown [127.0.0.6])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 8E89212159D;
        Tue, 28 Jun 2022 15:33:00 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1656430380; a=rsa-sha256;
        cv=none;
        b=yKBrzsWJ5dPoyqUvCFyC4mfxLsZdHCe6PzQfeJMTmbYRxL04gVJO2jRgACRXDCIOhsk1hT
        quq3hAZEM8KV9cL4fRdMVgwPeJVJrEMeRUqi9pNvcaB52PJI+m7GZfIB+sD7kO61zUFCH1
        DBHXMaxa6oXbFyRLpb+10WjUlDe4eSEcAQa15hL9cPSbvLmH4Lt085G77O3d2Ev2RUremv
        sMaM6S+vdj1uHrEepmtblz4ZWFRU7pL3sVf73KPpBUgy9V1MQOuObNpBFajQRPj+CgO1Gi
        KGcDLJpwczwZxjDh7eSY0IrRCE2vWqR5WHIH6iQEzMIPilBycGTJHW4WHkQCjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
        s=arc-2022; t=1656430380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:dkim-signature;
        bh=6PaLg0zce8LMNs1lHt4RTUDAxY3qsfhOcGADLKrynS8=;
        b=NSSOgRu8sh0Wyzm784OxYgEUjtabMPRwkzOam8zhEpghfUZ/kGLvuct4FRCk2B1XmH8Sdo
        Xk2YlLMCyXgNV+un6S3z3ISGc1O1fnD4pLcuw7ggZBCIprpzA4eg7D3MOXTv01fJc/D9bY
        Ss8uYiKw0uK2jLb4SwXpK2VvjOfr0cDh+aHlHUMaKBPeqiIgeO9QxS1lUwfdVS3MS4L1wl
        A9mroy7Iy/tQxGa93Q73+nWWrXXDDVNkKTAOKmFiRLbIttIjVuwYjFcSkJj9WuAFip9JVk
        gL6vpsAn8T+76TvkMnfuvkXQFlgzY2CSzJsChFUBd6umfrLRk6DkBwO9dQkegQ==
ARC-Authentication-Results: i=1;
        rspamd-674ffb986c-zqpf8;
        auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Wide-Eyed-Decisive: 3880163f225d940e_1656430380886_3243346417
X-MC-Loop-Signature: 1656430380886:3079928529
X-MC-Ingress-Time: 1656430380885
Received: from pdx1-sub0-mail-a228.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.124.238.92 (trex/6.7.1);
        Tue, 28 Jun 2022 15:33:00 +0000
Received: from offworld (unknown [104.36.31.105])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dave@stgolabs.net)
        by pdx1-sub0-mail-a228.dreamhost.com (Postfix) with ESMTPSA id 4LXTBM5vx0zLL;
        Tue, 28 Jun 2022 08:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
        s=dreamhost; t=1656430380;
        bh=6PaLg0zce8LMNs1lHt4RTUDAxY3qsfhOcGADLKrynS8=;
        h=Date:From:To:Cc:Subject:Content-Type;
        b=kK5YSzrsWQ9cQbjKuxowUWgzzeGmgepLWF5PgQj7/M2xckOLlma1s4hsLATiRxyrA
         3uXY1P/avJhWWsSgnuxM6ElADUMdhadVAOqEFRVi6bKzgHmtsUdWjm0LGEUHra//FM
         5LIDXTHkgb1GsxBvVj0giWrkqOa6I5QwP1tOf1cCEdY6DfYfZjtXK6yfoflKF3miVz
         IBzgq3yZjY+lqULPPh1WNR1kdv21xlV98o7Pd4NLmyO6qjvvNb05q5xu6GeLKJmFt9
         NeI0pG/PyV3lEKB2we3YcXjK08kYyjoohxicdQohG/t4Z0yrcYTaGh4pxcfkrZKgvw
         iPwZ1QKp5LLQg==
Date:   Tue, 28 Jun 2022 08:18:07 -0700
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        ejb@linux.ibm.com, tglx@linutronix.de,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 08/10] scsi/ibmvfc: Replace tasklet with work
Message-ID: <20220628151807.trtkagucvdmywisx@offworld>
References: <20220530231512.9729-1-dave@stgolabs.net>
 <20220530231512.9729-9-dave@stgolabs.net>
 <YqHn2Rn5nePSJ0PG@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YqHn2Rn5nePSJ0PG@linutronix.de>
User-Agent: NeoMutt/20220429
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 09 Jun 2022, Sebastian Andrzej Siewior wrote:

>On 2022-05-30 16:15:10 [-0700], Davidlohr Bueso wrote:
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
>> index d0eab5700dc5..31b1900489e7 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
>> @@ -891,7 +891,7 @@ static void ibmvfc_release_crq_queue(struct ibmvfc_host *vhost)
>>
>>	ibmvfc_dbg(vhost, "Releasing CRQ\n");
>>	free_irq(vdev->irq, vhost);
>> -	tasklet_kill(&vhost->tasklet);
>> +        cancel_work_sync(&vhost->work);
>s/ {8}/\t/
>
>is there a reason not to use threaded interrupts?

I went with a workqueue here because the resume from suspend also schedules
async processing, so threaded irqs didn't seem like a good fit. This is also
similar to patch 2 (but in that case I overlooked the resume caller which you
pointed out).

Thanks,
Davidlohr
