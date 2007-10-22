From: Benny Halevy <bhalevy@panasas.com>
Subject: Re: [PATCH 4/4] aic7xxx: Enable 16-bit CDBs
Date: Mon, 22 Oct 2007 23:24:49 +0200
Message-ID: <471D1521.3090405@panasas.com>
References: <20071019083239.D88FE18C61E@pentland.suse.de> <1192983563.3339.4.camel@localhost.localdomain> <471CF5B9.2090800@panasas.com> <20071022193551.GF27248@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sa14.bezeqint.net ([192.115.104.29]:47977 "EHLO
	sa14.bezeqint.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbXJVVYw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Oct 2007 17:24:52 -0400
In-Reply-To: <20071022193551.GF27248@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@SteelEye.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

On Oct. 22, 2007, 21:35 +0200, Matthew Wilcox <matthew@wil.cx> wrote:
> On Mon, Oct 22, 2007 at 09:10:49PM +0200, Boaz Harrosh wrote:
>> I'm about to finish an RFC patchset for the extended commands.
>> I have implemented a more aggressive approach than the one
>> I've been sending for the last year.
>> (Matthew I have an extra 8-bytes save to scsi_cmnd on 
>> 64bit and 12 bytes for 32bit. Guess how? ;))
> 
> Well ... the command has to be stored somewhere.  If it's an additional
> kmalloc, that's a loss.  If it's in the request, that's a loss too ...
> let's see where you're keeping it ;-)
> 
I love spoiling Boaz's surprise :)

The gist of it is scsi_cmnd->cmnd pointing at req->cmd
or at req->varlen_cmd as appropriate.

Most users can't tell the difference except if they
tried using sizeof(scsi_cmnd->cmnd) in which case they
can use MAX_COMMAND_SIZE instead.

Benny

