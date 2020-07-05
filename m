Return-Path: <SRS0=7Ct3=AQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ADF8C433E0
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Jul 2020 22:19:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68E042075B
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Jul 2020 22:19:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=hmh.eng.br header.i=@hmh.eng.br header.b="QfRTNG8O";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="P4NMHawI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbgGEWTg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Jul 2020 18:19:36 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:58245 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728103AbgGEWTf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Jul 2020 18:19:35 -0400
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 7DE945A5;
        Sun,  5 Jul 2020 18:19:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute7.internal (MEProxy); Sun, 05 Jul 2020 18:19:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hmh.eng.br; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=e/NX5vYxQ7aKi+cgflABISV+bap
        fSySPZCJVg0OvBuE=; b=QfRTNG8OFPg/678fvC1n9yAWw818SkKgW30DWbYyqfx
        msn97Ca4QhMFVO16dEHIYWlvgE4rGBT1xV/Av5wg7nI7i1TAjQHXgysUEWn+P9Ln
        ucazLqYS8+PaDYzOpvKSCglYB6l0W4lU3hN7XeJ6TosQSs3L2eF0TxcG50BEhOOm
        3jkg757mL+tKP2G+SNyVejHPLpVVKbHyDmEo6nAKT1CsH1MQFJtNcIElGvHPNi8g
        8HYG/+/FzgD+h2r6lMsZKuQ/ckEL46mILbE220S7GYFcMo+nXBLy5X8yOmlo0/3P
        RLewy9VnoHmiUYM9jxdbBY938xP2dj7CZUVc+6DR9cg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=e/NX5v
        YxQ7aKi+cgflABISV+bapfSySPZCJVg0OvBuE=; b=P4NMHawIDFlLRlv+lauV3h
        7dtyR530c1NOjgRDAgBVCKPnyMQc4hduirUdYlycczwatwOCtoQZfLGxzJysAh4W
        KP7mFd6j4Ehl0LbfmxqH6EzBImSj4/JZbxxhU8HokvGbi0svzMTqJHZ83hehjBq8
        9ySwtd9MagwE5z396IqP3hPIOs5aIK6WQwKuECmGUzfDsCnjgMYiXCcEwGzzZfA0
        MC2znx2TYsNw7vJBgQXhL3NBk7ShxBwMWhHGVsX4Aph0/Fv4hXIc6ifEiRqj8QsC
        4vAYbhnRSDkqfHa3paaxul70M6JccDInCIbEbeJ3dpDgveSJ6nrlqenOsWOkLRiA
        ==
X-ME-Sender: <xms:9VECXz4L2LQ5NhanODtDieopxRifv8yHjx7Og-TtsFs1-84VH-Ugbw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddvgddtiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttddttddtredvnecuhfhrohhmpefjvghnrhhi
    qhhuvgcuuggvucfoohhrrggvshcujfholhhstghhuhhhuceohhhmhheshhhmhhdrvghngh
    drsghrqeenucggtffrrghtthgvrhhnpeevudetjeegiedufeeugfeiheeljeekfeduhfej
    feegkeehkedvvdehheelgeevieenucfkphepudejjedrudelgedrjedrfedvnecuvehluh
    hsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhephhhmhheshhhmhhdr
    vghnghdrsghr
X-ME-Proxy: <xmx:9VECX46ZNINoIjfcL6Zy0KcTMIaj9iiZwiTNT8XX3-KVvWg2PZrSQQ>
    <xmx:9VECX6dNo8m19Z0ioeoY0ZmQ3RAkdt6sgY5-eE9jMvlh1Fnyz9yV5A>
    <xmx:9VECX0KGIz9o_rTPwFcEbhB6-nexr4Pq_Ts-ZgZ1rti-aoT8v0AFSQ>
    <xmx:9lECX0H846O_LOVqF5y7oMqWZneDkKKzjML-tOhQCCI-ptxVmRx5-Q>
Received: from khazad-dum.debian.net (unknown [177.194.7.32])
        by mail.messagingengine.com (Postfix) with ESMTPA id 48E743280063;
        Sun,  5 Jul 2020 18:19:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by localhost.khazad-dum.debian.net (Postfix) with ESMTP id 3322C340016C;
        Sun,  5 Jul 2020 19:19:31 -0300 (-03)
X-Virus-Scanned: Debian amavisd-new at khazad-dum.debian.net
Received: from khazad-dum.debian.net ([127.0.0.1])
        by localhost (khazad-dum2.khazad-dum.debian.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id YgCQtOJdWjXr; Sun,  5 Jul 2020 19:19:29 -0300 (-03)
Received: by khazad-dum.debian.net (Postfix, from userid 1000)
        id C06FC3400168; Sun,  5 Jul 2020 19:19:29 -0300 (-03)
Date:   Sun, 5 Jul 2020 19:19:29 -0300
From:   Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To:     Ming Lei <tom.leiming@gmail.com>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Simon Arlott <simon@octiron.net>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH] scsi: sd: stop SSD (non-rotational) disks before reboot
Message-ID: <20200705221929.GD8285@khazad-dum.debian.net>
References: <499138c8-b6d5-ef4a-2780-4f750ed337d3@0882a8b5-c6c3-11e9-b005-00805fc181fe>
 <CY4PR04MB37511505492E9EC6A245CFB1E79B0@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200623204234.GA16156@khazad-dum.debian.net>
 <CACVXFVNdC1U-gXdMr-B6i0WJdiYF+JvBcF3MkhFApEw_ZPx7pA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVNdC1U-gXdMr-B6i0WJdiYF+JvBcF3MkhFApEw_ZPx7pA@mail.gmail.com>
X-GPG-Fingerprint1: 4096R/0x0BD9E81139CB4807: C467 A717 507B BAFE D3C1  6092
 0BD9 E811 39CB 4807
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 30 Jun 2020, Ming Lei wrote:
> On Wed, Jun 24, 2020 at 5:01 AM Henrique de Moraes Holschuh
> <hmh@hmh.eng.br> wrote:
> > Cache flushes do not matter that much when SSDs and sudden power cuts
> > are involved.  Power cuts at the wrong time harm the FLASH itself, it is
> > not about still-in-flight data.
> >
> > Keep in mind that SSDs do a _lot_ of background writing, and power cuts
> 
> What is the __lot__ of SSD's BG writing? GC?

GC, and scrubbing.

> > during a FLASH write or erase can cause from weakened cells, to much
> > larger damage.  It is possible to harden the chip or the design against
> > this, but it is *expensive*.  And even if warded off by hardening and no
> > FLASH damage happens, an erase/program cycle must be done on the whole
> > erase block to clean up the incomplete program cycle.
> 
> It should have been SSD's(including FW) responsibility to avoid data loss when
> the SSD is doing its own BG writing, because power cut can happen any time
> from SSD's viewpoint.

Oh, I fully agree.  And yet, we had devices from several large vendors
complaining about unclean shutdowns.  So, "it should have been", as
usual, amounts to very little in the end.

> > When you do not follow these rules, well, excellent datacenter-class
> > SSDs have super-capacitor power banks that actually work.  Most SSDs do
> > not, although they hopefully came a long way and hopefully modern SSDs
> > are not as easily to brick as they were reported to be three or four
> > years ago.
> 
> I remember that DC SSDs often don't support BG GC.

And have proper supercap local power banks, etc.  I'd say they're not
really relevant to this thread.

-- 
  Henrique Holschuh
