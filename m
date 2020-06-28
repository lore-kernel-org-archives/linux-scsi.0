Return-Path: <SRS0=bO3J=AJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05043C433DF
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 19:42:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D92CD206A1
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 19:42:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=hmh.eng.br header.i=@hmh.eng.br header.b="c2KxKieR";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="LtENHqXH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgF1TmK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Jun 2020 15:42:10 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:51397 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726691AbgF1TmJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 28 Jun 2020 15:42:09 -0400
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 33EEC422;
        Sun, 28 Jun 2020 15:42:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute7.internal (MEProxy); Sun, 28 Jun 2020 15:42:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hmh.eng.br; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=FGcZt/6GMkSRNLSDs9gB3jrYVai
        8Gb9IKiujRYjF0bo=; b=c2KxKieRlGyL4lugZMvSumbQer6ZcVGoY79mqdNktlP
        EA9BS4lrBMXff3UF+drQ+OKGnoCo0m9lYl0kfQJ8brNc9y1NLUt7Sc/k6Hl11j5j
        H5Dex58q7zc4fLbVGq4/ldslSivmEeyVJITyjwR4HzxHL/h4Op8hUBbczmjzExFg
        V1DfXIHjUbqwGb25JRvUrUc1CJYlxt4kCmIBHGF0dgJLxXqQ/gmGv0lnvh6SzMHm
        s9NUcgmq2xrto0VOi+FjXxdgqC6yfXd/JaNhLl9Dk+czRikuzvV4R5PyxqooAsGV
        F9uhg2zT6OoPq4M8eBQgJZg/klXeTVnzXqGuml13vEw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=FGcZt/
        6GMkSRNLSDs9gB3jrYVai8Gb9IKiujRYjF0bo=; b=LtENHqXHroWzaMwe02bbjT
        Z6UDKOvW5rVJIcgJCqq4VH+n5M8CBpc3hcfPxwj/lXCQ15bEgarufzWB1LXOY0zS
        niUYegZl1lhSw1yk/TqnV1RW/jdmZErLF96dqHqxExJgMiYq39NRT2rd9T8p5Ttg
        Ff2JfTol87jVxtdvSfCtNdKNs/LX4ja4pHlM7Xm8hJhgIo8LA8ETwx0VlMEtSkmM
        5tIrwa57zXiVr5aPUUwUrKk48NmUf/ZMmAOBYSS0Zpwt5k45tafSY/KkJWEIVvBo
        9guG52VaZnrQzNi4mswQIPQ5KThcfBy8vWc3x3oBPa5Jv2hRGO6nqGPKzzuofChA
        ==
X-ME-Sender: <xms:jvL4Xvo5bgBZaO0zXy5vIbdioY7QHQzPTSzde8p9c3huu8PTbgJxzA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeliedgudegvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttddttddtredvnecuhfhrohhmpefjvghn
    rhhiqhhuvgcuuggvucfoohhrrggvshcujfholhhstghhuhhhuceohhhmhheshhhmhhdrvg
    hnghdrsghrqeenucggtffrrghtthgvrhhnpedtfeefvdffkeevjeeuffdvvdevveetjefg
    vdfhffeuteefvdevgeeuueejtddutdenucffohhmrghinheplhhkmhhlrdhorhhgnecukf
    hppedujeejrdduleegrdejrdefvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgr
    mhepmhgrihhlfhhrohhmpehhmhhhsehhmhhhrdgvnhhgrdgsrh
X-ME-Proxy: <xmx:jvL4Xppnc72eOJi3Amq7ZlpksP_mtyLe1zFDti1KvTPm6RhMCnz-Pw>
    <xmx:jvL4XsPQj179TK0CKyTNtl3oc6J5sUGSFDCcr239X3zyM7MqDfTPJw>
    <xmx:jvL4Xi6Bckveud57Q62bV0KqU-9JCQ7Ul7F0O8JI2HBYLuRXOtSesg>
    <xmx:j_L4XkmAWFdu1d9pOFGmyvEuilO1seWEYRFUL-Qmz4L11Ry1Pw__Ig>
Received: from khazad-dum.debian.net (unknown [177.194.7.32])
        by mail.messagingengine.com (Postfix) with ESMTPA id A45713280059;
        Sun, 28 Jun 2020 15:42:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by localhost.khazad-dum.debian.net (Postfix) with ESMTP id E20FA340015F;
        Sun, 28 Jun 2020 16:42:04 -0300 (-03)
X-Virus-Scanned: Debian amavisd-new at khazad-dum.debian.net
Received: from khazad-dum.debian.net ([127.0.0.1])
        by localhost (khazad-dum2.khazad-dum.debian.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id dA65gXlKiPuD; Sun, 28 Jun 2020 16:42:03 -0300 (-03)
Received: by khazad-dum.debian.net (Postfix, from userid 1000)
        id F130E3400159; Sun, 28 Jun 2020 16:42:02 -0300 (-03)
Date:   Sun, 28 Jun 2020 16:42:02 -0300
From:   Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To:     Simon Arlott <simon@octiron.net>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH] scsi: sd: stop SSD (non-rotational) disks before reboot
Message-ID: <20200628194202.GA9252@khazad-dum.debian.net>
References: <499138c8-b6d5-ef4a-2780-4f750ed337d3@0882a8b5-c6c3-11e9-b005-00805fc181fe>
 <CY4PR04MB37511505492E9EC6A245CFB1E79B0@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200623204234.GA16156@khazad-dum.debian.net>
 <4e9c7e62-b1e4-80b0-8e22-9d57d3431f37@0882a8b5-c6c3-11e9-b005-00805fc181fe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e9c7e62-b1e4-80b0-8e22-9d57d3431f37@0882a8b5-c6c3-11e9-b005-00805fc181fe>
X-GPG-Fingerprint1: 4096R/0x0BD9E81139CB4807: C467 A717 507B BAFE D3C1  6092
 0BD9 E811 39CB 4807
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 28 Jun 2020, Simon Arlott wrote:
> On 23/06/2020 21:42, Henrique de Moraes Holschuh wrote:
> > [1] I have long lost the will and energy to pursue this, so *this* is a
> > throw-away anecdote for anyone that cares: I reported here a few years
> > ago that many models of *SATA* based SSDs from Crucial/Micron, Samsung
> > and Intel were complaining (through their SMART attributes) that Linux
> > was causing unsafe shutdowns.
> > 
> > https://lkml.org/lkml/2017/4/10/1181
> > 
> > TL;DR: wait one *extra* second after the SSD acknowleged the STOP
> > command as complete before you trust the SSD device is safe to be
> > powered down (i.e. before reboot, suspend, poweroff/shutdown, and device
> > removal/detach).  This worked around the issue for every vendor and
> > model of SSD we tested.
> 
> Looking through that thread, it looks like a simple 1 second delay on
> shutdown/reboot patch hasn't been proposed yet?

It should work, yes.  And it likely would help with whatever $RANDOM
other hardware that has the same issues but has no way to make itself
noticed, so *I* would appreciate it as something I could tell the kernel
to *always* do.

But for "sd" devices, it would be likely more complete to also ensure
the delay for device removal (not just on reboot and power off).

> In my case none of the SSDs are recording unexpected power loss if they
> are stopped before the reboot, but the reboot won't necessarily be
> instantaneous after the last stop command returns.

Yes, it is a race.  If either the SSD happens to need less "extra" time,
or the computer takes a bit longer to reboot/power off, all is well.
Otherwise, the SSD loses the race, and gets powered down at an
inappropriate time.

-- 
  Henrique Holschuh
