From: "Jan Beulich" <JBeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH 1/4] Add XEN pvSCSI protocol
 description
Date: Mon, 30 Jun 2014 12:29:20 +0100
Message-ID: <53B16630020000780001E830@mail.emea.novell.com>
References: <1403879676-25431-1-git-send-email-jgross@suse.com>
 <1403879676-25431-2-git-send-email-jgross@suse.com>
 <20140627171154.GA30451@laptop.dumpdata.com>
 <53B15FFA020000780001E79E@mail.emea.novell.com> <53B14798.70303@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.emea.novell.com ([130.57.118.101]:53555 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaF3L3X (ORCPT
	<rfc822;groupwise-linux-scsi@vger.kernel.org:5:1>);
	Mon, 30 Jun 2014 07:29:23 -0400
In-Reply-To: <53B14798.70303@suse.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Juergen Gross <JGross@suse.com>
Cc: xen-devel@lists.xen.org, JBottomley@parallels.com, linux-scsi@vger.kernel.org

>>> On 30.06.14 at 13:18, <JGross@suse.com> wrote:
> On 06/30/2014 01:02 PM, Jan Beulich wrote:
>>>>> On 27.06.14 at 19:11, <konrad.wilk@oracle.com> wrote:
>>> On Fri, Jun 27, 2014 at 04:34:33PM +0200, jgross@suse.com wrote:
>>>> +/*
>>>> + * Maximum scatter/gather segments per request.
>>>> + *
>>>> + * Considering balance between allocating at least 16 "vscsiif_re=
quest"
>>>> + * structures on one page (4096 bytes) and the number of scatter/=
gather
>>>> + * elements needed, we decided to use 26 as a magic number.
>>>> + */
>>>> +#define VSCSIIF_SG_TABLESIZE		26
>>>> +
>>>> +/*
>>>> + * based on Linux kernel 2.6.18
>>>
>>> This being a bit more .. new, - do these sizes make sense anymore?
>>> Should they be extended a bit? Or have support for using the
>>> old ones (as default) and then negotiate new sizes with the kernel?
>>> (If of course there is a difference?)
>>
>> As J=C3=BCrgen already said (and as you should have noticed yourself=
) -
>> this is an interface definition that we can't just change. Negotiati=
on
>> of larger counts is an option, which is what VSCSIIF_ACT_SCSI_SG_PRE=
SET
>> is intended for (the implementation of which isn't part of this patc=
hset
>> afaics, but could be made available on top of it).
>=20
> I don't think this is the proper way to handle larger SG lists. The
> VSCSIIF_ACT_SCSI_SG_PRESET option would just bump the maximum length
> up to 31 (currently 26). Or was it thought to be incremental (multipl=
e
> presets for one request)?

Yes, that's how it's to be used. See xen-vscsi-large-requests.patch
it the newer of our trees.

> I'd rather add a way to specify SG lists
> residing in an own (granted) page (or even multiple pages). This woul=
d
> allow 512*26 SG entries without having to change the request structur=
e.
> The capability to handle this feature could be indicated via xenstore=
=2E

And yes, considering the similar changes in blkif I agree that this
would be the preferred method today. That patch, however,
predates those blkif enhancements.

Jan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
