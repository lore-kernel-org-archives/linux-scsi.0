From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: Yet another hot unplug NULL pointer dereference (was Re: status
 of oops in sd_revalidate_disk?)
Date: Thu, 16 Feb 2012 10:04:03 +0900
Message-ID: <4F3C5603.1040108@ce.jp.nec.com>
References: <4EE8E419.8010000@pre-sense.de> <CAO+b5-pCW-F1nD365TnEiAfoN7zKB4zXkk3uO6p5QyUPY2icsA@mail.gmail.com> <20120214143800.69703df9@stein> <2173642.Y3HxI15Hxl@asus> <4F3B17C7.9040107@ce.jp.nec.com> <CAO+b5-rNF1R5NcSdVSsKLML4wyZBBGv-zUdq+B1y0kfHxLpupA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAO+b5-rNF1R5NcSdVSsKLML4wyZBBGv-zUdq+B1y0kfHxLpupA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, jbottomley@parallels.com, linux-scsi@vger.kernel.org, Huajun Li <huajun.li.lee@gmail.com>, Axel Theilmann <theilmann@pre-sense.de>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

On 02/15/12 20:29, Bart Van Assche wrote:
> On Wed, Feb 15, 2012 at 3:26 AM, Jun'ichi Nomura <j-nomura@ce.jp.nec.com> wrote:
>> I think this patch is good, too.
>> Since QUEUE_FLAG_DEAD is also racy, it is not much different
>> from queuedata check, IMO.
> 
> Are you sure ? As far as I know the block layer takes care of
> synchronizing queue flag modifications against request_fn invocations.

QUEUE_FLAG_DEAD is set outside of queue_lock. So it's racy.
However, it's single directional change and the race is benign
if the driver, who sets QUEUE_FLAG_DEAD, is ready to reject
requests.
q->queuedata is same with that regard.

-- 
Jun'ichi Nomura, NEC Corporation
