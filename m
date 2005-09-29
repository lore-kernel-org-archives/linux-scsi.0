From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [dm-devel] RE: [RFC PATCH 4/4] convert scsi to blkerr error values
Date: Wed, 28 Sep 2005 21:28:56 -0500
Message-ID: <433B5168.1020405@cs.wisc.edu>
References: <C2EEB4E538D3DC48BF57F391F422779321ACB6@SRMANNING.eng.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:11163 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751315AbVI2C3E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Sep 2005 22:29:04 -0400
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321ACB6@SRMANNING.eng.emc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: axboe@suse.de, linux-scsi@vger.kernel.org

goggin, edward wrote:
> Mike,
> 
> I don't think it is reasonably possible to anticipate
> all possible parsing requirements for the asc and ascq
> portions of SCSI sense information across all device
> models.  I'm in favor of having a "small" framework in
> SCSI where a SCSI sense interpreter module (per
> vendor & model possibly) could be registered
> dynamically, by dm-emc.c for instance.
> 
> The extended error interpreter callout would be
> triggered indirectly by a call from
> __end_that_request_first to a extended error parser
> associated with the io request's queue whenever it
> sees a non-zero sense field of the io request.
> Perhaps the sense and sense_len fields in the
> request structure should be changed to not be
> SCSI specific.
> 
> Also, in order to allow for more variation and detail
> in the interpretation of device specific SCSI asc and
> ascq values, the results of the interpretation should
> not be required to be block layer generic, but instead
> are saved in something like a void *bi_extended_error
> field of the bio.  __end_that_request_first would push
> the results of the extended_error interpretation to the
> bi_extended_error field of each bio in the request,
> similar to how Jens's code currently works.
> 

I have been working on this but a issue I was wondering about is what to 
do when someone other than dm-multipath wants to know about this special 
error value. For example when we first discover devices if it is passive 
path, we have to go through the pain of the regular setup and any 
retires that arise from it. If people are not going to complain about 
this anymore then you can ignore this mail :) But the problem (or issue 
people gripe about) is that if there is a magic ASC/ASCQ value for 
vendor XYZ that indicates we are sending requests to a passive path then 
who decodes the bi_extended_error value when dm-mutliapth is not used? 
Will we have to have a vendor specific bi_extended_error decoder for 
dm-mpath, filesystems and buffer head code, and what about SCSI?
