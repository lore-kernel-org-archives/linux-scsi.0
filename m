Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D12CC433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 13:01:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E517364EE0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 13:01:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235311AbhCANBb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 08:01:31 -0500
Received: from authsmtp15.register.it ([81.88.48.38]:43229 "EHLO
        authsmtp.register.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S235304AbhCANBZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 08:01:25 -0500
Received: from [192.168.43.2] ([176.201.234.222])
        by cmsmtp with ESMTPSA
        id Gi6nlCeXPf5o5Gi6olmqTm; Mon, 01 Mar 2021 13:57:11 +0100
X-Rid:  guido@trentalancia.com@176.201.234.222
Message-ID: <1614603429.6918.18.camel@trentalancia.com>
Subject: Re: [PATCH RESEND v2] scsi: ignore Synchronize Cache command
 failures to keep using drives not supporting it
From:   Guido Trentalancia <guido@trentalancia.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Date:   Mon, 01 Mar 2021 13:57:09 +0100
In-Reply-To: <BL0PR04MB6514A85C4B56E1370406B97BE79A9@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <1614502908.6594.6.camel@trentalancia.com>
         <443d92dd844e329bcd40a1e59b7cc3784ed3db94.camel@HansenPartnership.com>
         <1614582394.13266.11.camel@trentalancia.com>
         <BL0PR04MB65146856C07649917652E540E79A9@BL0PR04MB6514.namprd04.prod.outlook.com>
         <1614598394.4338.18.camel@trentalancia.com>
         <BL0PR04MB651420859C04C068419711FDE79A9@BL0PR04MB6514.namprd04.prod.outlook.com>
         <1614602388.6918.8.camel@trentalancia.com>
         <BL0PR04MB6514A85C4B56E1370406B97BE79A9@BL0PR04MB6514.namprd04.prod.outlook.com>
X-Priority: 1
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfIZuI7myZCaHu1Y+hl1GlMQddh4Nx3s12BDXhW9PtosMhJvIpelBegu9YqvMkppkHiYbe8eZBYuHYO6k6BYRqi5xaBvX+iPIRqMmyiX/3Wuni8Eq+tZH
 gbwhAvjKljFZW91e73HrL8k34kh4hV7sASY8WCzkE29WtIRfYfm11ejbjZCyoi+CAzXNtIO9PuW0opMHlPctSZiX1WkwFH5KTH16QQvP3RpZc93Wi0aRDm9c
 9yg17qTS8235xetZGnxi2Q==
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 01/03/2021 at 12.51 +0000, Damien Le Moal wrote:
> On 2021/03/01 21:39, Guido Trentalancia wrote:
> > If the system is shut down before the sync or drive unmounting and
> > the
> > write cache is enabled, there might be the loss of data in the
> > cache,
> > but this is because of the way the drive is designed.
> 
> That drive is not usable. Even the best journaling file system would
> get corrupted.

It is usable and an ext3 filesystem has not been causing any problem
for over a year now.

> > I believe the kernel should support the drive as it is - plug and
> > play
> > - without requiring cumbersome configurations.
> 
> No. That would be lying to the user. The user expect things to work.
> Not data
> corruptions.

Data corruption is what occurs with the current kernel when one of such
drives is mounted.

With the patch the drive can be used normally and no data corruption
occurs with the drive that I have tested.

This is a proposed patch and nobody is lying, I can report the specific
drive model that I have tested and the tests can be easily replicated
to confirm my findings.

Guido
