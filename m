Return-Path: <SRS0=K8op=A2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 814DEC433E3
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 09:26:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5781220674
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 09:26:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=octiron.net header.i=@octiron.net header.b="mS2x6lyq";
	dkim=pass (2048-bit key) header.d=octiron.net header.i=@octiron.net header.b="oN/opcW7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730683AbgGOJ0N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jul 2020 05:26:13 -0400
Received: from chalk.uuid.uk ([51.68.227.198]:51732 "EHLO chalk.uuid.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729890AbgGOJ0M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Jul 2020 05:26:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=octiron.net
        ; s=20180214; h=Message-ID:References:In-Reply-To:Subject:Cc:To:From:Date:
        Content-Transfer-Encoding:Content-Type:MIME-Version:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=BuxXrpb686ptaZ1HCHsKcx9WQB5LeIW7vA9uRU9DVeE=; b=mS2x6lyqgl9S1NYxKolQ3u+MOw
        B2QGyLs7CSV+ZU7KaEXhMS3iS0GeixJdOkDAMIP7bv1al73Im79MYGV3rWPzHhfq/dh/+QpsevpdV
        01p9bxNO/iJUiY5S3VS1qrodVODH3fnEYG4qrrpv/eLEvAb8sSLBlWqiuXsAW2m51JzBGYXbMiayU
        URqSiouTZo4HuH1dSGt3dO2/19zYyGSDV/WfmDaJaeC9VNfUn8wUFs/B8Tek/d5ZrucAMawQ3F9sa
        S2o5QJoASdWbJBq2YVj9U2PyZ7+unBTga87tezN/4AKIcvPm3Y0l424HF7PQWQTXxlwVkU6OBqhX6
        OcrEoVhg==;
Received: by chalk.uuid.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <simon@octiron.net>)
        id 1jvdfm-0005i1-4N; Wed, 15 Jul 2020 10:25:59 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=octiron.net
        ; s=20180214; h=Message-ID:References:In-Reply-To:Subject:Cc:To:From:Date:
        Content-Transfer-Encoding:Content-Type:MIME-Version;
        bh=BuxXrpb686ptaZ1HCHsKcx9WQB5LeIW7vA9uRU9DVeE=; b=oN/opcW7Llpdn+3P9i4ewgdFha
        x1UfAtQbGeo129n6GyLA0manluVHBBKL3KUtMkihJI6OujbKtf9uMg7EWMg6HaEja2NpanRF97yeM
        lYwG1ylVQNyzIkgk/REnO9lwI2hakWaVx+b3DjGEnBot15iCB4GifSPx/bX3KS9VrZ/TwzMaU68cR
        BqeqTwZCSCyLri9uo7dXDF/z8R4sAZsPeKQNdgmNqHyxveuolRKoPZH3befcSF44/MW+RDBlH8qkK
        P4/jPGSurFtvSp0SKxV7Q/J9JytrL+8X3A7xC3u5A2ojI5nJPgYVl6E9XY+Rr8QPGu1cUGJejUSsV
        +fPtqjSg==;
Received: by tsort.uuid.uk with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <simon@octiron.net>)
        id 1jvdfj-0004dX-Bh; Wed, 15 Jul 2020 10:25:51 +0100
Received: from localhost ([::1]:44858)
        by skund.uuid.uk with esmtp (Exim 4.86_2)
        (envelope-from <simon@octiron.net>)
        id 1jvdfj-0000oB-8E; Wed, 15 Jul 2020 10:25:51 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 15 Jul 2020 10:25:51 +0100
From:   Simon Arlott <simon@octiron.net>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH (v2)] scsi: sd: add parameter to stop disks before reboot
In-Reply-To: <yq1bll1fi9u.fsf@ca-mkp.ca.oracle.com>
References: <e726ffd8-8897-4a79-c3d6-6271eda8aebb@0882a8b5-c6c3-11e9-b005-00805fc181fe>
 <20200629080947.GA28551@infradead.org>
 <yq1bll1fi9u.fsf@ca-mkp.ca.oracle.com>
Message-ID: <3d3799e1-5c4c-b82d-5f35-88144df1cc1f@0882a8b5-c6c3-11e9-b005-00805fc181fe>
X-Sender: simon@octiron.net
User-Agent: Roundcube Webmail/1.2-beta
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 30/06/2020 02:35, Martin K. Petersen wrote:
>> What happened to the suggestion to treat reboot=p like a poweroff
>> instead?  That seems to be fundamentally the right thing to do.
> 
> I agree!

I've done that but so far it has been ignored:
https://lore.kernel.org/lkml/f4a7b539-eeac-1a59-2350-3eefc8c17801@0882a8b5-c6c3-11e9-b005-00805fc181fe/

-- 
Simon Arlott
