From: Christoph Hellwig <hch@infradead.org>
Subject: Re: twa generates WARNING upon boot
Date: Wed, 30 Sep 2015 09:31:47 -0700
Message-ID: <20150930163147.GA2928@infradead.org>
References: <68ee66bf9581d10b0ab813e5006869ec.squirrel@atoth.sote.hu>
 <CAHtARFHdFOVHZ2_-JT9_nvRZmbF+cffRrtaaE4DSZSrJwU6BCA@mail.gmail.com>
 <d8e4bcdc939f0926a63f5c4a35fb8e0c.squirrel@atoth.sote.hu>
 <1443548266.2207.19.camel@HansenPartnership.com>
 <1443549768.2207.22.camel@HansenPartnership.com>
 <95d34bcc4c0fcf84d02d76a4443ba07c.squirrel@atoth.sote.hu>
 <1443551581.2207.26.camel@HansenPartnership.com>
 <20150930160835.GA16534@infradead.org>
 <1443629730.2185.25.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48241 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292AbbI3Qbs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Sep 2015 12:31:48 -0400
Content-Disposition: inline
In-Reply-To: <1443629730.2185.25.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, "\"T?th Attila\"" <atoth@atoth.sote.hu>, adam radford <aradford@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Sep 30, 2015 at 09:15:30AM -0700, James Bottomley wrote:
> I already thought of this.  Unfortunately, it fails if the internally
> posted command is a single sector (the size of TW_MIN_SGL_LENGTH), which
> is true for most of them.

Which internally posted command?  All the usual suspects set
tw_dev->srb[request_id] to NULL and thus neither have a scsi_cmnd
associated with them, nor will they ever reach a code path where we call
twa_command_mapped().
