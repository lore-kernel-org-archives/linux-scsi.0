From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH] scsi: sd_dif.c use unaligned access helpers
Date: Fri, 25 Jul 2008 22:14:00 -0700
Message-ID: <1217049240.5971.51.camel@brick>
References: <1216854460.30386.32.camel@brick>
	 <yq1od4l8eb2.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:22953 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbYGZFOC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Jul 2008 01:14:02 -0400
Received: by wa-out-1112.google.com with SMTP id j37so2284362waf.23
        for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2008 22:14:02 -0700 (PDT)
In-Reply-To: <yq1od4l8eb2.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>

On Sat, 2008-07-26 at 00:22 -0400, Martin K. Petersen wrote:
> >>>>> "Harvey" == Harvey Harrison <harvey.harrison@gmail.com> writes:
> 
> [Sorry about the delayed response.  I've been traveling for a few
> days.]
> 
> Harvey> This code should be looked at carefully, while this patch
> Harvey> doesn't change any behaviour, the handling of app_tag, ref_tag
> Harvey> seems odd.  The struct defines both as __be16/32 but in these
> Harvey> locations it is read in/written out as cpu-byteorder.
> 
> The opaque tag space (app in Type 1+2, app + ref in Type 3) is
> provided for use by filesystems.  The SCSI layer doesn't know anything
> about the contents of the tag buffer.  It has no idea whether it
> contains bytes, shorts, ints or longs.  So we can't swab on the
> assumption that each DIF tuple contains an u16.  Just like we don't
> byteswap any other data coming down from above.
> 
> Filesystems must prepare tags in an endianness-aware fashion just like
> they prepare normal filesystem metadata.  And at the SCSI layer we
> treat it as a byte stream.

OK.  But everywhere in this file app_tag is treated as host-order,
and causes no end of sparse warnings.

Looking just at type1 (with some comments):

static void sd_dif_type1_set_tag(void *prot, void *tag_buf, unsigned int sectors)
{
	struct sd_dif_tuple *sdt = prot;
	char *tag = tag_buf;
	unsigned int i, j;

	for (i = 0, j = 0 ; i < sectors ; i++, j += 2, sdt++) {
//app_tag is host-order, read in as raw byte in be-order
		sdt->app_tag = tag[j] << 8 | tag[j+1];
		BUG_ON(sdt->app_tag == 0xffff);
	}
}

static void sd_dif_type1_get_tag(void *prot, void *tag_buf, unsigned int sectors)
{
	struct sd_dif_tuple *sdt = prot;
	char *tag = tag_buf;
	unsigned int i, j;

	for (i = 0, j = 0 ; i < sectors ; i++, j += 2, sdt++) {
//app_tag is host order again, read out in be-byteorder
		tag[j] = (sdt->app_tag & 0xff00) >> 8;
		tag[j+1] = sdt->app_tag & 0xff;
	}
}

So who cares what the spec says, the code is treating it as a host-order
u16 everywhere.  Similarly for the ref_tag.  So if you're going to 
manipulate them in host-order, just declare the struct in host order.

Anyways, maybe I'm mistaken here.

Harvey



