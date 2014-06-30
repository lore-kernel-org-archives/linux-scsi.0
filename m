From: "Jan Beulich" <JBeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH 1/4] Add XEN pvSCSI protocol
 description
Date: Mon, 30 Jun 2014 12:02:50 +0100
Message-ID: <53B15FFA020000780001E79E@mail.emea.novell.com>
References: <1403879676-25431-1-git-send-email-jgross@suse.com>
 <1403879676-25431-2-git-send-email-jgross@suse.com>
 <20140627171154.GA30451@laptop.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.emea.novell.com ([130.57.118.101]:52535 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbaF3LC4 (ORCPT
	<rfc822;groupwise-linux-scsi@vger.kernel.org:5:1>);
	Mon, 30 Jun 2014 07:02:56 -0400
In-Reply-To: <20140627171154.GA30451@laptop.dumpdata.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xen.org, JBottomley@parallels.com, Juergen Gross <JGross@suse.com>, linux-scsi@vger.kernel.org

>>> On 27.06.14 at 19:11, <konrad.wilk@oracle.com> wrote:
> On Fri, Jun 27, 2014 at 04:34:33PM +0200, jgross@suse.com wrote:
>> +/*
>> + * Maximum scatter/gather segments per request.
>> + *
>> + * Considering balance between allocating at least 16 "vscsiif_requ=
est"
>> + * structures on one page (4096 bytes) and the number of scatter/ga=
ther
>> + * elements needed, we decided to use 26 as a magic number.
>> + */
>> +#define VSCSIIF_SG_TABLESIZE		26
>> +
>> +/*
>> + * based on Linux kernel 2.6.18
>=20
> This being a bit more .. new, - do these sizes make sense anymore?
> Should they be extended a bit? Or have support for using the
> old ones (as default) and then negotiate new sizes with the kernel?
> (If of course there is a difference?)

As J=C3=BCrgen already said (and as you should have noticed yourself) -
this is an interface definition that we can't just change. Negotiation
of larger counts is an option, which is what VSCSIIF_ACT_SCSI_SG_PRESET
is intended for (the implementation of which isn't part of this patchse=
t
afaics, but could be made available on top of it).

Most if not all of your other comments are a little questionable too
in this context - any parts you aren't happy about would really
better be addressed towards the canonical header in the Xen tree.
(I know you had other interface headers diverge too in their Linux
incarnation, but personally I don't think this is an appropriate thing
to do, perhaps apart for pure coding style adjustments.)

Jan

Jan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
