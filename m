From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: why store the search type in the ieee name field?
Date: Tue, 11 Feb 2003 08:46:56 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030211084656.A27826@beaverton.ibm.com>
References: <3E482B9E.40803@mvista.com> <1044918776.1776.257.camel@mulgrave> <20030211082039.A27630@beaverton.ibm.com> <1044981839.1774.10.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1044981839.1774.10.camel@mulgrave>; from James.Bottomley@steeleye.com on Tue, Feb 11, 2003 at 10:43:57AM -0600
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Steven Dake <sdake@mvista.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Feb 11, 2003 at 10:43:57AM -0600, James Bottomley wrote:

> No, look at the code.  After doing name[0] = hex_str[...
> it then does a strcat.  If name is full of junk, strcat will append
> after the first \0 it finds (which may be off the end of the name
> field).  It only works because name[1] is zero but nothing seems to
> clear it.  I'm hoping it's being cleared in a piece of code I haven't
> found yet...
> 
> James

Yes - there's a memset() in scsi_load_identifier, plus on error some of
the fields are re-zeroed (a bit ugly).

-- Patrick Mansfield
