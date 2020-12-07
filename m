Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBEDBC4361B
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 18:08:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86E24233A1
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 18:08:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgLGSII (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 13:08:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbgLGSIH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 13:08:07 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8147CC061794;
        Mon,  7 Dec 2020 10:07:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xeFJmOIDufW34ETJisVrK6EvU//eljbrPd80Wffmy7c=; b=IL1Rn3H3sOwVBVgF107DDFcwNO
        GpsD4NWkiVYOXKVhDUsqV683Api7FNwRfEI/ZEgbOrVUhzTJ26P8sIAKg2yUqtIWYtjx84RupQ0fG
        DxuYZ5oNeVo7iRXeFgbJJlEovw1TI7UNbA6AQJ4EZ5jSjYE4MRdoO8YFkw1oUm0dyqmtDaDKMhlnv
        BGjdhcl0LgCVqfzOvSsbqTTCsmEHRyJBIbrUwBaP4gKkoxFAFcf2qh13fmMPTS4PCgUAJ3VB3QSEY
        VHMQQXLNWcKWrzedYTggMB3izLKNIEC+P+fmtic/JwlFmgu5/GG8Q0ZCGehAFfjlwtWbqsBzWjlRx
        JI/GCwfw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kmKuV-00082C-Lt; Mon, 07 Dec 2020 18:06:55 +0000
Date:   Mon, 7 Dec 2020 18:06:55 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Greg KH <greg@kroah.com>
Cc:     Daejun Park <daejun7.park@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "gregkh@google.com" <gregkh@google.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
Subject: Re: [PATCH v13 0/3] scsi: ufs: Add Host Performance Booster Support
Message-ID: <20201207180655.GA30657@infradead.org>
References: <CGME20201103044021epcms2p8f1556853fc23414442b9e958f20781ce@epcms2p8>
 <2038148563.21604378702426.JavaMail.epsvc@epcpadp3>
 <X85sxxgpdtFXiKsg@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X85sxxgpdtFXiKsg@kroah.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Dec 07, 2020 at 06:56:23PM +0100, Greg KH wrote:
> On Tue, Nov 03, 2020 at 01:40:21PM +0900, Daejun Park wrote:
> > Changelog:
> > 
> > v12 -> v13
> > 1. Cleanup codes by comments from Can Guo.
> > 2. Add HPB related descriptor/flag/attributes in sysfs.
> > 3. Change base commit from 5.10/scsi-queue to 5.11/scsi-queue.
> 
> What ever happened to this patchset?  Did it get merged into a scsi tree
> for 5.11-rc1, or is there something still pending that needs to be done
> on it to make it acceptable?

I think the problem here is not the code, but that the features is
fundamentally a bad idea, and one that so far has not even shown
to help real workloads vs the usual benchmarketing.
