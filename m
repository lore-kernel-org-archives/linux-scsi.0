From: Juergen Gross <jgross@suse.com>
Subject: Re: [Xen-devel] [PATCH 1/4] Add XEN pvSCSI protocol description
Date: Mon, 30 Jun 2014 13:18:48 +0200
Message-ID: <53B14798.70303@suse.com>
References: <1403879676-25431-1-git-send-email-jgross@suse.com>	<1403879676-25431-2-git-send-email-jgross@suse.com>	<20140627171154.GA30451@laptop.dumpdata.com> <53B15FFA020000780001E79E@mail.emea.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41148 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbaF3LSw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Jun 2014 07:18:52 -0400
In-Reply-To: <53B15FFA020000780001E79E@mail.emea.novell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Beulich <JBeulich@suse.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Juergen Gross <JGross@suse.com>, linux-scsi@vger.kernel.org, JBottomley@parallels.com, xen-devel@lists.xen.org

On 06/30/2014 01:02 PM, Jan Beulich wrote:
>>>> On 27.06.14 at 19:11, <konrad.wilk@oracle.com> wrote:
>> On Fri, Jun 27, 2014 at 04:34:33PM +0200, jgross@suse.com wrote:
>>> +/*
>>> + * Maximum scatter/gather segments per request.
>>> + *
>>> + * Considering balance between allocating at least 16 "vscsiif_req=
uest"
>>> + * structures on one page (4096 bytes) and the number of scatter/g=
ather
>>> + * elements needed, we decided to use 26 as a magic number.
>>> + */
>>> +#define VSCSIIF_SG_TABLESIZE		26
>>> +
>>> +/*
>>> + * based on Linux kernel 2.6.18
>>
>> This being a bit more .. new, - do these sizes make sense anymore?
>> Should they be extended a bit? Or have support for using the
>> old ones (as default) and then negotiate new sizes with the kernel?
>> (If of course there is a difference?)
>
> As J=C3=BCrgen already said (and as you should have noticed yourself)=
 -
> this is an interface definition that we can't just change. Negotiatio=
n
> of larger counts is an option, which is what VSCSIIF_ACT_SCSI_SG_PRES=
ET
> is intended for (the implementation of which isn't part of this patch=
set
> afaics, but could be made available on top of it).

I don't think this is the proper way to handle larger SG lists. The
VSCSIIF_ACT_SCSI_SG_PRESET option would just bump the maximum length
up to 31 (currently 26). Or was it thought to be incremental (multiple
presets for one request)? I'd rather add a way to specify SG lists
residing in an own (granted) page (or even multiple pages). This would
allow 512*26 SG entries without having to change the request structure.
The capability to handle this feature could be indicated via xenstore.

> Most if not all of your other comments are a little questionable too
> in this context - any parts you aren't happy about would really
> better be addressed towards the canonical header in the Xen tree.
> (I know you had other interface headers diverge too in their Linux
> incarnation, but personally I don't think this is an appropriate thin=
g
> to do, perhaps apart for pure coding style adjustments.)


Juergen

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
