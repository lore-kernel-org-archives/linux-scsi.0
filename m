Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B829C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Feb 2022 00:12:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbiBAAME (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 19:12:04 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:53363 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230261AbiBAAMD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 31 Jan 2022 19:12:03 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id EF7CE32020B3;
        Mon, 31 Jan 2022 19:12:02 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 31 Jan 2022 19:12:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/1aaaxrgtRY0w6b1U
        HzVRQID+8LtfwK8veNAyx0Iu5M=; b=NknPmPtiyiaqr0o6j5aZdV/4BL3ubK9RU
        6m+i4w+AwJOazVznPjjWEd6uFqtL8CpAiuKQlzVBCm3tjXyQ1OX+0LuzpxLceAES
        fkJSyQ/uOi5jADU/4RkqcnpHOI6C6bWeXj9deUD7Agd5M3IySnptJbspBIlocRxJ
        6dNlg4EGbCFTbvKTRRH7ctxxkD6FTMqJSP8z4MfbAjPx7bvRlD+NINcE5/z/7LPi
        cFJA0tZYMJWUDRCBTYo5OCf8owBiouZfF/k0A4Z2fhHSzYdePCKztdEMKcwb0XBv
        wTr4AFTTYZ/jU1yLDmERcyG+gtK8BNq/hGlLaOTxpw21Kyz05b06A==
X-ME-Sender: <xms:0Xr4YYLahlYTu6GHGh22AKkbris_A_t6pEydqiS4hyQpyUEf6jjenA>
    <xme:0Xr4YYLxiXNQiyUXjZ7WA0yEChwwG8vLsJkko6vNs2hqqN0A3eugZRuBBP1B3L-dc
    HtAZQSS0b0HxQBAGDQ>
X-ME-Received: <xmr:0Xr4YYv47nfSCVDiUt-AYbO5Dk4xhH8bHdrq961-unp1RqsnjoRzr29Qpuj01-0YA2RpamYSP7fEBcaJBSO3XXMaI9MkSapMzLI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrgedvgddulecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvufgjkfhfgggtsehmtderredttdejnecuhfhrohhmpefhihhnnhcuvfhh
    rghinhcuoehfthhhrghinheslhhinhhugidqmheikehkrdhorhhgqeenucggtffrrghtth
    gvrhhnpeefffejiefgheevheefvefhteeggfeijeeiveeihfffffdugfefkeelfffhgfeh
    vdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehfth
    hhrghinheslhhinhhugidqmheikehkrdhorhhg
X-ME-Proxy: <xmx:0nr4YVYhFLPyzc9x_wR8t--akMm3Nzl3xbUjwHg1ipiNdWcX5H4mxA>
    <xmx:0nr4YfY5EeHvNwE0WASZ8NCm6kXjVsekBPbP2L3AF1q9lpRQEMy7sw>
    <xmx:0nr4YRBOF5ISYT_BWxF2z9pkS7BpAWqSM51ze-npSxDkaFyH6By1vg>
    <xmx:0nr4YeXxGL0k131fGGf9gKvPW35LMNqdXSeDh7O5oX-vQuZ6QiLzxQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 31 Jan 2022 19:11:59 -0500 (EST)
Date:   Tue, 1 Feb 2022 11:11:52 +1100 (AEDT)
From:   Finn Thain <fthain@linux-m68k.org>
To:     Bart Van Assche <bvanassche@acm.org>
cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH 05/44] NCR5380: Move the SCSI pointer to private command
 data
In-Reply-To: <11e386f4-239a-3c04-ae20-f47fdc0d8df6@acm.org>
Message-ID: <6e52c0e0-31ce-b438-e3b6-28bbfbb35f8f@linux-m68k.org>
References: <20220128221909.8141-1-bvanassche@acm.org> <20220128221909.8141-6-bvanassche@acm.org> <f8dc3a5f-55a7-6cc-b210-d0cd1b7a96c2@linux-m68k.org> <11e386f4-239a-3c04-ae20-f47fdc0d8df6@acm.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463811774-1961172306-1643674312=:18228"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811774-1961172306-1643674312=:18228
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 31 Jan 2022, Bart Van Assche wrote:

> On 1/31/22 14:39, Finn Thain wrote:
> > Regarding code style, this is legacy code i.e. it pre-dates the ban on
> > mixed letter case. (I'm using the word legacy after the dictionary
> > definition and not as a kind of weasel word intended to mean deprecated=
=2E)
> >=20
> > Mixed case names like "BAZ5000_cmd" would be frowned upon for new code =
but
> > this is not new code. So why not just use the name SCp for variables wh=
ich
> > serve the same purpose that the SCp struct did?
> >=20
> > IOW, I would prefer to read the following, because SCp presumably means
> > "Scsi Command Private data" whereas "scsi_pointer" means nothing to me.
>=20
> Changing the struct member name "scsi_pointer" back into "SCp" in this dr=
iver
> is fine with me. In case this wouldn't be clear: I think the name "SCSI
> pointer" refers to a section in the SCSI-II standard. From the SCSI-II
> standard: "6.4 SCSI pointers
> Consider the system shown in figure 17 in which an initiator and target
> communicate on the SCSI bus in order to execute an I/O process. The SCSI
> architecture provides for a set of three pointers for each I/O process, c=
alled
> the saved pointers. The set of three pointers consist of one for the comm=
and,
> one for the data, and one for the status. When an I/O process becomes act=
ive,
> its three saved pointers are copied into the initiator=E2=80=99s set of t=
hree current
> pointers. There is only one set of current pointers in each initiator. Th=
e
> current pointers point to the next command, data, or status byte to be
> transferred between the initiator=E2=80=99s memory and the target. The sa=
ved and
> current pointers reside in the initiator. The saved command pointer alway=
s
> points to the start of the command descriptor block (see 7.2) for the I/O
> process. The saved status pointer always points to the start of the statu=
s
> area for the I/O process. The saved data pointer points to the start of t=
he
> data area until the target sends a SAVE DATA POINTER message (see 6.6.20)=
 for
> the I/O process."
>=20
> I think the above quote shows that the contents of struct scsi_pointer ha=
s
> been derived directly from the SCSI-II specification.
>=20

But only acornscsi.c and fas216.c actually use the SCp.ptr field in the=20
way that you describe.

While I agree that struct scsi_pointer was probably somehow intended to=20
mean "saved data pointer", that just proves my point as to the poor choice=
=20
of name.

Anyway, I'm not interested in bikeshedding variable names. I'll let the=20
maintainer make the call rather than attempt to veto these patches.
---1463811774-1961172306-1643674312=:18228--
