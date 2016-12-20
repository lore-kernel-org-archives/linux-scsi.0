From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] set a base index for libsas based ata devices
Date: Tue, 20 Dec 2016 10:30:34 -0800
Message-ID: <1482258634.2475.20.camel@HansenPartnership.com>
References: <CAF2xp_F3ea-n4R8jG8UpHEE3YmvKN7UWBAn36_QXMg-e34tY_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAF2xp_F3ea-n4R8jG8UpHEE3YmvKN7UWBAn36_QXMg-e34tY_w@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Peter Chang <dpf@google.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2016-12-20 at 10:15 -0800, Peter Chang wrote:
> we discovered this when futzing w/ the queue depth parameter for ata
> disks behind the pm8006 controller. setting depth == 1 should disable
> ncq, but the sysfs part silently fails and we continue sending the
> fpdma command variants. no one else probably cares about the 
> disabling ncq path, but we do like to test.

I'd actually disagree with this assertion; it's why tagging (what you
mean by ncq) and queue depth are separate.  Queue depth represents the
number of outstanding commands we sent on the wire; however, it often
excludes things like sense probes and error handling commands, so
tagged depth==1 is a different operating environment from untagged. 
 Some transports actually have no untagged variant nowadays, so it's
physically impossible to disable tagging.

James

> anyway, adding both the ide and scsi lists because i'm not quite sure
> there's a separate libsas list and a single commit seems better for
> this.



