Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FB27C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jun 2022 15:02:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234872AbiFIPCy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jun 2022 11:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231807AbiFIPCx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jun 2022 11:02:53 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A03E614B67A
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jun 2022 08:02:52 -0700 (PDT)
Date:   Thu, 9 Jun 2022 17:02:49 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1654786970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rsv9agcb7AdhLP1srXUy5ncNQtch/vDr6u6vmLWao2w=;
        b=BKUSuWB/KmoHcHKcJnNQtVcpblcVCQ8GBsGICPRbx5UNwamrAA2o8DCHyE7WwNSpa/LvN6
        bsTZqUp1C8bF7xeNzMpiHbyMeJ6AVEsFBn/uhF4y47zyEYPrBwNr9Rvn+mYFkp381bgWDh
        ltzyfMG4/X+sQOrJzQ9v6EuxLRD6mkMcuglvNHrQanhxtmWOcVVl88UOciUonrOoc4zQDf
        4Uav6tqyWPWC+u65VsvdTJ7o1ZAHkUF1SWtp8b8y9n0YYJaw569HawQwMzfe/eSH0yJdgn
        kk10mA7QBRaZOObPL770b32AE9Omh/lB1VJNm9CeA2Hm0hq1XTM1pbWfA9ot4w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1654786970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rsv9agcb7AdhLP1srXUy5ncNQtch/vDr6u6vmLWao2w=;
        b=vvuxQZEA1uPGaBJ79e2W7phxX23trtU+OPmEU+bcwiSrqBkZXi0XOGMsqYNzvwEBL0t3xd
        X0vzmUkgd7AM6yAg==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Davidlohr Bueso <dave@stgolabs.net>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        ejb@linux.ibm.com, tglx@linutronix.de,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 09/10] scsi/ibmvscsi: Replace srp tasklet with work
Message-ID: <YqILmd/WnNT/zYrf@linutronix.de>
References: <20220530231512.9729-1-dave@stgolabs.net>
 <20220530231512.9729-10-dave@stgolabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220530231512.9729-10-dave@stgolabs.net>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022-05-30 16:15:11 [-0700], Davidlohr Bueso wrote:
> Tasklets have long been deprecated as being too heavy on the system
> by running in irq context - and this is not a performance critical
> path. If a higher priority process wants to run, it must wait for
> the tasklet to finish before doing so.
> 
> Process srps asynchronously in process context in a dedicated
> single threaded workqueue.

I would suggest threaded interrupts instead. The pattern here is the
same as in the previous driver except here is less locking.

Sebastian
