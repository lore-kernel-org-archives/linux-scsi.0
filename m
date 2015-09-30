From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: twa generates WARNING upon boot
Date: Wed, 30 Sep 2015 09:36:24 -0700
Message-ID: <1443630984.2185.27.camel@HansenPartnership.com>
References: <68ee66bf9581d10b0ab813e5006869ec.squirrel@atoth.sote.hu>
	 <CAHtARFHdFOVHZ2_-JT9_nvRZmbF+cffRrtaaE4DSZSrJwU6BCA@mail.gmail.com>
	 <d8e4bcdc939f0926a63f5c4a35fb8e0c.squirrel@atoth.sote.hu>
	 <1443548266.2207.19.camel@HansenPartnership.com>
	 <1443549768.2207.22.camel@HansenPartnership.com>
	 <95d34bcc4c0fcf84d02d76a4443ba07c.squirrel@atoth.sote.hu>
	 <1443551581.2207.26.camel@HansenPartnership.com>
	 <20150930160835.GA16534@infradead.org>
	 <1443629730.2185.25.camel@HansenPartnership.com>
	 <20150930163147.GA2928@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41353 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751279AbbI3Qg2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Sep 2015 12:36:28 -0400
In-Reply-To: <20150930163147.GA2928@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "\"T?th Attila\"" <atoth@atoth.sote.hu>, adam radford <aradford@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2015-09-30 at 09:31 -0700, Christoph Hellwig wrote:
> On Wed, Sep 30, 2015 at 09:15:30AM -0700, James Bottomley wrote:
> > I already thought of this.  Unfortunately, it fails if the internally
> > posted command is a single sector (the size of TW_MIN_SGL_LENGTH), which
> > is true for most of them.
> 
> Which internally posted command?  All the usual suspects set
> tw_dev->srb[request_id] to NULL and thus neither have a scsi_cmnd
> associated with them, nor will they ever reach a code path where we call
> twa_command_mapped().

Are you sure?  The init trace that kicked all this off still has
twa_init in it.  I was figuring the most likely suspect is
twa_get_param().

James


