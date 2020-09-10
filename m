Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2B96C433E2
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 16:11:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9143C206A1
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 16:11:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="SqTOBGdd";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="SqTOBGdd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbgIJQKs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Sep 2020 12:10:48 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54580 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725820AbgIJQJo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Sep 2020 12:09:44 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id B4B848EE11E;
        Thu, 10 Sep 2020 09:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1599754150;
        bh=vjqoZjjs4ZL988BGG7sXtVJHzIb1zQDOeZ88/1JThQw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SqTOBGdd05DEXZCUAUSRCFQLQh+D8HlmsHDZknIpCoLNKWMiASjKLlkwGQpE1qB2y
         Ra66T5QAZClQDQ1tI6wCPqz6A+A1azS+MUvPfnrYOwq0bWYX6ZlSPFX3WbX9nPfwsv
         HXiNLeDe7+r88pNXMcY6eguRdu3R4RQu703OyKHk=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id c7vL7lTQ-z-f; Thu, 10 Sep 2020 09:09:10 -0700 (PDT)
Received: from [153.66.254.174] (c-73-35-198-56.hsd1.wa.comcast.net [73.35.198.56])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 6C6ED8EE0E2;
        Thu, 10 Sep 2020 09:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1599754150;
        bh=vjqoZjjs4ZL988BGG7sXtVJHzIb1zQDOeZ88/1JThQw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SqTOBGdd05DEXZCUAUSRCFQLQh+D8HlmsHDZknIpCoLNKWMiASjKLlkwGQpE1qB2y
         Ra66T5QAZClQDQ1tI6wCPqz6A+A1azS+MUvPfnrYOwq0bWYX6ZlSPFX3WbX9nPfwsv
         HXiNLeDe7+r88pNXMcY6eguRdu3R4RQu703OyKHk=
Message-ID: <1599754148.3575.4.camel@HansenPartnership.com>
Subject: Re: [PATCH v2 1/2] scsi: ufs: Abort tasks before clear them from
 doorbell
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
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
Date:   Thu, 10 Sep 2020 09:09:08 -0700
In-Reply-To: <1599725880.10649.35.camel@mtkswgap22>
References: <1599099873-32579-1-git-send-email-cang@codeaurora.org>
         <1599099873-32579-2-git-send-email-cang@codeaurora.org>
         <1599627906.10803.65.camel@linux.ibm.com>
         <yq14ko62wn5.fsf@ca-mkp.ca.oracle.com>
         <1599706080.10649.30.camel@mtkswgap22>
         <1599718697.3851.3.camel@HansenPartnership.com>
         <1599725880.10649.35.camel@mtkswgap22>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-09-10 at 16:18 +0800, Stanley Chu wrote:
[...]
> > + 	if (!err) {
> >  +cleanup:
> 
> Yeah, considering Bean Huo's patch "scsi: ufs: No need to send Abort
> Task if the task in DB was cleared", "cleanup" label shall be added
> back here.
> 
> So your resolution looks good to me.
> 
> Thanks so much : )

You're welcome ... but just remember I have to explain this to Linus
when the merge window opens.  It would be a lot easier if this hadn't
happened so please don't make it any worse ...

James

