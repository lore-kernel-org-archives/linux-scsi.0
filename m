Return-Path: <SRS0=bO3J=AJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81C7EC433E1
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 18:22:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6599220757
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 18:22:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=octiron.net header.i=@octiron.net header.b="eilfXp4G";
	dkim=pass (2048-bit key) header.d=octiron.net header.i=@octiron.net header.b="Q3IHCgKP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgF1SWw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Jun 2020 14:22:52 -0400
Received: from djelibeybi.uuid.uk ([45.91.101.70]:54656 "EHLO
        djelibeybi.uuid.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbgF1SWw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Jun 2020 14:22:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=octiron.net
        ; s=20180214; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4mU9y8QsGrtsB3UMcJ3MEP+O4sbWpkrpCYlB2e8o70g=; b=eilfXp4GhmbmUimaHND0GVd4Ck
        mMIK0p8ILO6XxGQvDIlKA0JBruCbd5GP47/jAYyD1oxhc2YD1xlRpnyyl0OV0PjvaUj5EXBIXc5wg
        kyTTHhF+sLT7iUfdUILatEX4cUiirJtv6nbgBfC+zDDdsSZLDs5bluXwofO9TZ/4HhUqn57FvkFjr
        alx/xHma1neaH+LA4B6QekFi1n8s2iCi8pOPA5DWs68y1Un7nJqQl7PCU/i83nR32D9Y0ozUDPrSN
        TzLNIzPHL0uSu4xsNGLtIa6ehOurq+0Cd54nYS631Jo3z5uyu6wrZnOkFnXMnug8OUsVZcnMmn6IQ
        /63gmFKw==;
Received: by djelibeybi.uuid.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <simon@octiron.net>)
        id 1jpbwo-0006Ea-J5; Sun, 28 Jun 2020 19:22:40 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=octiron.net
        ; s=20180214; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject;
        bh=4mU9y8QsGrtsB3UMcJ3MEP+O4sbWpkrpCYlB2e8o70g=; b=Q3IHCgKP+MtExOhAufQ3oWGwfZ
        j0bSbxDzuimk0mwwK7HOpY925G7zqavf20GnAnXjHazjMR1KMk0I7ot9CVrYz5NIY5MTqly81BOYp
        Kg/+3I9+ONocWos3m0JtRGXqIXe0ROVntRMow7WXVnvgCv//eAZPbNyX06bvPvIudf+2EHBGjhAww
        tpKka5vQFRoUyEQ3O81xoChH6FJ5mZpf+jCY6LVCYLUAK0MdT1L3sGYYxy+ra88ts7Z73GFrmnIdD
        DtrbXqqmcW9e1Hso8guT+XyKznEAzYlPyPFXZILtGDuwsLSvKHglreDI75MWocP20TaGfc7w+0jOM
        cAtjj/nA==;
Received: by tsort.uuid.uk with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <simon@octiron.net>)
        id 1jpbwk-0007EF-Jo; Sun, 28 Jun 2020 19:22:31 +0100
Subject: Re: [PATCH] scsi: sd: stop SSD (non-rotational) disks before reboot
To:     Pavel Machek <pavel@ucw.cz>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
References: <499138c8-b6d5-ef4a-2780-4f750ed337d3@0882a8b5-c6c3-11e9-b005-00805fc181fe>
 <CY4PR04MB37511505492E9EC6A245CFB1E79B0@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200623133618.GE2783@bug>
From:   Simon Arlott <simon@octiron.net>
Message-ID: <e6900a15-1e75-1ef9-91c9-b118c7c627da@0882a8b5-c6c3-11e9-b005-00805fc181fe>
Date:   Sun, 28 Jun 2020 19:22:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200623133618.GE2783@bug>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 23/06/2020 14:36, Pavel Machek wrote:
> Many SSDs are buggy, and will eventually corrupt themselves if you do enough
> sudden power loss experiments.
> 
> HDDs don't like their power cut, either. You can hear the difference 
> between normal power off and power cut...

I will change the patch so that it doesn't distinguish between types of
disks.

The default will have to be the existing behaviour (don't stop disks)
because most reboots shouldn't result in a loss of power.

-- 
Simon Arlott
