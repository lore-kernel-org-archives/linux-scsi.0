From: Don Brace <Don.Brace@pmcs.com>
Subject: RE: [PATCH] scsi: hpsa: fix multiple issues in path_info_show
Date: Wed, 18 Nov 2015 18:27:34 +0000
Message-ID: <07F70BBF6832E34FA1C923241E8833AB7D0546D2@BBYEXM01.pmc-sierra.internal>
References: <1445984203-3288-1-git-send-email-linux@rasmusvillemoes.dk>
	<56313105.3050805@pmcs.com> <87mvuga9jr.fsf@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87mvuga9jr.fsf@rasmusvillemoes.dk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Don Brace <brace77070@gmail.com>
Cc: Joe Handzik <joseph.t.handzik@hp.com>, "James E.J. Bottomley" <JBottomley@odin.com>, Kevin Barnett <Kevin.Barnett@pmcs.com>, Scott Teel <Scott.Teel@pmcs.com>, Tomas Henzl <thenzl@redhat.com>, "iss_storagedev@hp.com" <iss_storagedev@hp.com>, dl Team ESD Storage Dev Support <storagedev@pmcs.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Rasmus Villemoes
> Sent: Saturday, November 14, 2015 9:24 AM
> To: Don Brace
> Cc: Joe Handzik; James E.J. Bottomley; Kevin Barnett; Scott Teel; Tomas Henzl;
> iss_storagedev@hp.com; dl Team ESD Storage Dev Support; linux-
> scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] scsi: hpsa: fix multiple issues in path_info_show
> 
> On Wed, Oct 28 2015, Don Brace <brace77070@gmail.com> wrote:
> 
> > On 10/27/2015 05:16 PM, Rasmus Villemoes wrote:
> >> I'm not familiar with this code, but path_info_show() (added in
> >> 8270b86243658 "hpsa: add sysfs entry path_info to show box and
> >> bay information") seems to be broken in multiple ways.
> >>
> [snip]
> >>
> >> We can fix all of that and get rid of the 400 byte stack buffer by
> >> simply writing directly to the given output buffer, which the upper
> >> layer guarantees is at least PAGE_SIZE. s[c]nprintf doesn't care where
> >> it is writing to, so this doesn't make the spin lock hold time any
> >> longer. Using scnprintf ensures that output_len always represents the
> >> number of bytes actually written to the buffer, so we'll report the
> >> proper amount to the upper layer.
> >>
> >> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> >>
> > Thanks, I added this to my current patch set. This patch will be up
> > with you as the author soon.
> 
> I see it in mainline now. May I ask why 6 out of 7 scnprintfs were
> changed (back) to snprintf? I don't think there's any functional
> difference as long as PAGE_SIZE is indeed sufficient, but mixing
> snprintf and scnprintf is pretty odd, and there's now a discrepancy
> between the commit log and the patch which wasn't in my original - I'd
> expect a "[use snprintf because xyz]" note added if the change was
> intentional.
> 
> Rasmus

Unintentional.
I'll upload a fix soon.


> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
