From: Brian Waite <waite@skycomputers.com>
Subject: Re: [RFC] [PATCH] 0/7 2.5.35 SCSI multi-path
Date: Thu, 19 Sep 2002 17:29:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200209191729.24069.waite@skycomputers.com>
References: <Pine.LNX.3.96.1020919171118.24603A-100000@gatekeeper.tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.3.96.1020919171118.24603A-100000@gatekeeper.tmr.com>
List-Id: linux-scsi@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>, Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

This is why we had to make another abstraction layer that was the "uniqueness 
driver" This allowed the admin to configure a device without seial numbers to 
be multipathed if they knew it was multipathed by explicitly specifing the 
host bus, target, lun of all the paths to a speciic device. We never got the 
chance to develop an intellegent way a determining multipathed-ness so we 
left it to the user. Not ideal but it worked for our customer.  I would like 
to think there is a better way to determind uniqueness, but the nice thing 
was we made the uniquness driver a module that could be replaced, thus 
letting us develop new uniqueness algorithms in the future. I think the 
concept is good, maybe not the implimentation. It also allows you to say you 
don't like how we do... well you know the rest 


Thanks
Brian

On Thursday 19 September 2002 5:16 pm, Bill Davidsen wrote:
> On Wed, 18 Sep 2002, Patrick Mansfield wrote:
> > Devices without serial numbers are treated as if they had different
> > serial numbers, they show up as if there was no multi-path support.
>
> That doesn't solve the problem, does it? If you have two devices w/o
> serial they could look like one with multipath, with the change you note
> that is prevented by making a single multipath device w/o serial look like
> two. I have visions of programs using /dev/st0 and /dev/st1, having used
> backup programs which grabbed every drive with a tape ready.
>
> It is indeed a messy problem.

