Return-Path: <SRS0=Iqxk=77=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E6CEC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 12:32:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FFA2207E8
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 12:32:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=octiron.net header.i=@octiron.net header.b="UxoWk3h3";
	dkim=pass (2048-bit key) header.d=octiron.net header.i=@octiron.net header.b="x8aZ/Cuc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729409AbgFRMb5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Jun 2020 08:31:57 -0400
Received: from papylos.uuid.uk ([185.34.62.16]:39844 "EHLO papylos.uuid.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726982AbgFRMb4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Jun 2020 08:31:56 -0400
X-Greylist: delayed 378 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Jun 2020 08:31:55 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=octiron.net
        ; s=20180214; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=B+4Gs/0j/CESrZMyfibpjnqye8gtYFkuSwBCEo4B4VU=; b=UxoWk3h38JdZskTb8k+g1JvlSX
        J5meE/UfbOPHdvXFp37nuu03bS2qMZvlCfKTubNavPntxMInBBDpGlIPj8dUY4cmIDi1swo1koauR
        WNrHn7VZYfILoctfwqGfoEolGDj9BGipBbCSLbYZiqXNIIc0Zj3xPJXIrmRuAvYOg0PM0KmgWpuhP
        0SVZLXWj/QaIB3kVDfpgP2WvC1sJyRfK7TwBauFz+C6XoB2C2dEhH/k7+EcTSP+q8tbaV3tpkTp3F
        k+ZPRU7PxOaWQkJbtLZgXP06q+6RyK3hcStGxkT5U2cY2TWtACQq1A3BSWYe6Q75JFh2ra/zyfEIy
        rngaYrCQ==;
Received: by papylos.uuid.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <simon@octiron.net>)
        id 1jltbe-0002ue-PS; Thu, 18 Jun 2020 13:25:29 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=octiron.net
        ; s=20180214; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject;
        bh=B+4Gs/0j/CESrZMyfibpjnqye8gtYFkuSwBCEo4B4VU=; b=x8aZ/CucIHuoSAuaPxrBMUKSLr
        KJK8ZF8FACElj/AlLKrUtED2J1vemTCikrWSh5nFeyf/w7eK/i+WMGcflRSk+lHGQ/HMDG9inpQSR
        i1SS25kjnbQutg8MG2eIZI6NPVJu/3pR2/mNWe6cYfrG2UgQ3biYMkgvzo4vq2FpSXzhUA1eSX3la
        oRKtFhpHjFvr9kNkmn7ZOHharZILBuU7GfCnse+UrfxBj+Wpco/NBNSEAxTt3/FHk2QcTYbbu5XV5
        TF4cVtmZFPK2Fjw9G2q1YRwN19VMFZ2B8Hd1TT7rDyJpOYLtd0vmy3Y2dCpjVBehw01Z20zo6b8P1
        9zmrx4FA==;
Received: by tsort.uuid.uk with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <simon@octiron.net>)
        id 1jltba-0005r9-6N; Thu, 18 Jun 2020 13:25:18 +0100
Subject: Re: [PATCH] scsi: sd: stop SSD (non-rotational) disks before reboot
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org
References: <499138c8-b6d5-ef4a-2780-4f750ed337d3@0882a8b5-c6c3-11e9-b005-00805fc181fe>
 <20200618072138.GA11778@infradead.org>
From:   Simon Arlott <simon@octiron.net>
Message-ID: <9877e7de-d573-694b-2b75-95192756684b@0882a8b5-c6c3-11e9-b005-00805fc181fe>
Date:   Thu, 18 Jun 2020 13:25:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200618072138.GA11778@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 18/06/2020 08:21, Christoph Hellwig wrote:
> On Wed, Jun 17, 2020 at 07:49:57PM +0100, Simon Arlott wrote:
>> Avoiding a stop of the disk on a reboot is appropriate for HDDs because
>> they're likely to continue to be powered (and should not be told to spin
>> down only to spin up again) but the default behaviour for SSDs should
>> be changed to stop them before the reboot.
> 
> I don't think that is true in general.  At least for most current server
> class and older desktop and laptop class systems they use the same
> format factors and enclosures, although they are slightly divering now.
> 
> So I think this needs to be quirked based on the platform and/or
> enclosure.

Are you referring to the behaviour for handling HDDs or SSDs?

For HDDs, the default "1" option could mean "automatic" and apply to
rotational disks when power loss is expected.

For SSDs, I don't think an extra stop should ever be an issue.

-- 
Simon Arlott
