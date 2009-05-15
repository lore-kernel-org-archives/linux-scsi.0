From: Ravish Tayal <ravish.tayal@gmail.com>
Subject: Fwd: Query to optimize PageCache size in system
Date: Fri, 15 May 2009 11:21:56 +0530
Message-ID: <e42309110905142251v7bce0203p486a0cceacdffe82@mail.gmail.com>
References: <e42309110905130732xf4313a6qba1f30a2d89728be@mail.gmail.com>
	 <e42309110905130805r135c3373xa6ecda0e45180d34@mail.gmail.com>
	 <20090513155444.GF15360@parisc-linux.org>
	 <e42309110905142210k332b8818l695a03efdc75673f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-px0-f123.google.com ([209.85.216.123]:43527 "EHLO
	mail-px0-f123.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757864AbZEOFvz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2009 01:51:55 -0400
In-Reply-To: <e42309110905142210k332b8818l695a03efdc75673f@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-arm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-usb@vger.kernel.org
Cc: ravish.tayal@conexant.com

Including Linux mailing list in the mail thread.

Thanks Matthew,
Please see my inline explanations.

On Wed, May 13, 2009 at 9:24 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> On Wed, May 13, 2009 at 08:35:52PM +0530, Ravish Tayal wrote:
>> I am looking for help to reduce the number of cached pages in the
>> system. I am using 2.6.12 linux kernel on ARM processor.for my
>> embedded USB mass storage application.
>

> Why do you think the number of cached pages is a problem? =A0What pro=
blem
> are you experiencing that you think is caused by having a large numbe=
r
> of cached pages?
>
RT: My intention is to keep the Zone->nr_inactive to be minimum. By
which I means in case File system read operation pages which are in
active list should alow to be part of the page cache, while once moved
to inactive list it should be soon aged out to free list.
Which for embedded scenario would allow low memory devices to keep
good amount of free memory.

Currently I am periodically calling try_to_free_pages to get it done ;-=
)

>> 3. Is there any provision in linux kernel through which I can restri=
ct
>> the new page allocation for disk operation to not to be added in the
>> page-cache =A0?

>> 4. If I open the file with O_DIRECT Flag would page_cache be avoided=
,
>> irrespective it is file read or File write operations?
>
> Question 4 appears to be the answer to question 3. =A0O_DIRECT works =
for
> both reads and writes, but does have restrictions on alignment.
>

RT: I tried to use the O_DIRECT options with bftpd ftp =A0server +
2.6.12 kernel, In File write operation I have observed no difference
in term page caching behaviour.
Though in that setup file read operation starts failining which I
didn't debug much.

Thanks for your suggestion.
regards
Ravish Tayal
> --
> Matthew Wilcox =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Int=
el Open Source Technology Centre
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours. =A0We can't possibly take s=
uch
> a retrograde step."
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
