From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: why store the search type in the ieee name field?
Date: 10 Feb 2003 17:12:54 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1044918776.1776.257.camel@mulgrave>
References: <3E482B9E.40803@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id PAA31862
	for <linux-scsi@vger.kernel.org>; Mon, 10 Feb 2003 15:12:59 -0800
In-Reply-To: <3E482B9E.40803@mvista.com>
List-Id: linux-scsi@vger.kernel.org
To: Steven Dake <sdake@mvista.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2003-02-10 at 16:45, Steven Dake wrote:
> Folks,
> 
> I was wondering the reasoning behind the code
> 
> scsi_scan:734
>         /*
>          * All OK - store ID
>          */
>       name[0] = hex_str[id_search->id_type];
> 
> This corrupts a perfectly good IEEE unique identifier (WWN for FC 
> drives).  Is there some usage for this in user space?

Erm, it's appending the type to the beginning of the name string
(although it does seem to be relying on the sysfs name field being zero
filled).  I don't see any corruption since the inquiry fields and unique
name name follows this byte.

You get the identifier it found from the sysfs name file for the
device.  The first byte tells you what type of unique name you're
dealing with.

James


