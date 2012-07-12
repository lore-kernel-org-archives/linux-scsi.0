From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: [PATCH v3 3/5] st: get rid of scsi_tapes array
Date: Thu, 12 Jul 2012 15:09:30 -0400
Message-ID: <4FFF20EA.6030706@suse.com>
References: <4FBACC66.80208@suse.com> <alpine.LNX.2.00.1207011147110.3650@kai.makisara.local> <4FF239F8.7030101@suse.com> <4FFDC938.4050606@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57918 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932833Ab2GLTJi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jul 2012 15:09:38 -0400
In-Reply-To: <4FFDC938.4050606@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: Kai Makisara <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 7/11/12 2:43 PM, Lee Duncan wrote:
> Kai:
> 
> Your added patch looks great, and I see you fixed the documentation
> as well. Thanks for your help.
> 

Actually, we've run into a hiccup here. Using cdev as the target of
the link doesn't work, the tape symlink isn't created, and we end up
with lsscsi not listing tape device nodes.

I'll work up a fix.

- -Jeff

> On 07/02/2012 05:16 PM, Lee Duncan wrote:
>> 
>> On 07/01/2012 01:57 AM, Kai Makisara wrote:
>>> On Mon, 21 May 2012, Lee Duncan wrote:
>>> 
>>>> From: Jeff Mahoney <jeffm@suse.com>
>>>> 
>>>> st currently allocates an array to store pointers to all of
>>>> the scsi_tape objects. It's used to discover available
>>>> indexes to use as the base for the minor number selection and
>>>> later to look up scsi_tape devices for character devices.
>>>> 
>>>> We switch to using an IDR for minor selection and a pointer
>>>> from st_modedef back to scsi_tape for the lookups.
>>>> 
>>>> Signed-off-by: Jeff Mahoney <jeffm@suse.com> Signed-off-by:
>>>> Lee Duncan <lduncan@suse.com> --- drivers/scsi/st.c |  172
>>>> ++++++++++++++++++++--------------------------------- 
>>>> drivers/scsi/st.h |    2 + 2 files changed, 65 insertions(+),
>>>> 109 deletions(-)
>>>> 
>>> ... patch removed
>>> 
>>> I have finally had time to review and test this patch set. I am
>>> sorry this has taken so long.
>>> 
>>> I have found one change of behaviour and a theoretical
>>> problem: The new code does not re-use the tape numbers when
>>> freed and re-scanned. The current code does re-use the freed
>>> numbers. Are there any reasons for this changed behaviour? (The
>>> theoretical problem is that the new code frees the tape
>>> structure but leaves the pointer in the idr tree.)
>>> 
>>> The patch at the end of this message (applies after the whole
>>> series) is an attempt to implement re-use of tape numbers. I am
>>> not completely sure that the change is correctly placed but it
>>> seems to work.
>> 
>> 
>> Thanks for the review, and good catch. I'll look over your added
>> patch and give feedback as soon as I can.
>> 
>>> 
>>> Another minor thing is that the documentation should be updated
>>> :-)
>> 
>> Of course.
>> 
>>> 
>>> The patch at the end also updates the version code. I am not
>>> sure if the version code is useful, but it should be either
>>> updated or removed.
>>> 
>>> Otherwise no problems found. I am ready to ack the patch set
>>> after the re-use thing has been resolved (one way or another).
>>> 
>>> Thanks, Kai
>>> 
> 
> - Lee
> 


- -- 
Jeff Mahoney
SUSE Labs


-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.18 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJP/yDqAAoJEB57S2MheeWyVQIQAK51+gbTWNkak42ZrJp9oyv4
6kBMkvD2/iJkcMFeg4dLxiIhuJKPVzqExBvRrk8Yvu4eWhvNBUt27KVtrMC3uzNn
utZhzZebp6qpUTwHp6cD+XJXtcHqyn04OpOxWq/oiRmJaffI/sgluLJKV7xQZpns
tV4vvhN00sGZ1CIJqJMj7g2dOk4k+kb6CXIQsKCIb/r25rLEH8f9YVAzo3jAJFrv
YPbyzC5OHDvghpiJZlm/H9Tp2VTovSjrITrGAp+g8fzXA4LKnx2Q+N5yfMF5lWaI
OXVyt97aGiYJRtxvdbTvtcf3CD7vsUVYqFdRVE8/5St1TsKQ9oqOJoKcb7jgTtmx
02rbZC8fsh0OTgyDlV+Ktja6knyWTHgVPqobUumx10wTpQYo1q00u/rqBXi3VEsS
swpbOcU20S+wetnBAkX50g+kCgfRskjj0nodDfCfGl/NgfDNe7sbAoc6NVDaaAGw
+h4pkyWsl8z0Uhj9Eju7Sbu6aAwjthxWTAKvz3TSuFffRmFf8Z55sc+UxouosXkX
hR7H/grUlk80J+rOyh+31Lx1707XcMSmnQSG0ZWePNOIukMkps0d3IXnRf6cHZ1/
0nnOxGfIQI/bo+WcDqhd2s5hlg9ZNCCe/JYoTj6jn040P63xxRK+soCNL0I+Ql4h
wnpeyXbDdDc6cBpp+jpf
=8KWj
-----END PGP SIGNATURE-----
