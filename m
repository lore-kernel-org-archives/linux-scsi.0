From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 00/11] First pass at merging Bart's HA work
Date: Thu, 6 Dec 2012 17:46:33 +0200
Message-ID: <50C0BDD9.20100@mellanox.com>
References: <cover.1353903448.git.dillowda@ornl.gov> <CAL1RGDU+b4GxEoY0TOvkyJjr0yx=5tFNmAVZ27hVjOOx=n=yJg@mail.gmail.com> <1353957308.2681.5.camel@dabdike> <1353989041.28917.24.camel@obelisk.thedillows.org> <CAL1RGDXpdWL_r7sWp=vvvXH4jxFgjDL+XcEGgKo-44=wrOBmtA@mail.gmail.com> <1354242098.3670.3.camel@obelisk.thedillows.org> <CAJZOPZJBTRXftrW5NWEEHnf2QWsni0HMTAV_PKSgDtA7GO=wRw@mail.gmail.com> <50BF9760.2080801@acm.org> <CAJZOPZKPs5Vx5nB3610V+byv9p1KvL7+sRU6G4uMTRQu=4=STw@mail.gmail.com> <50C0A76C.20500@acm.org> <50C0AB42.8040402@mellanox.com> <50C0B407.4010706@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50C0B407.4010706-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, rcj-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, Alex Turin <alextu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 06/12/2012 17:04, Bart Van Assche wrote:
> On 12/06/12 15:27, Or Gerlitz wrote:
>> The core problem here seems to be that scsi_remove_host simply never 
>> ends.
>
> Hello Or,
>
> The later patches in the srp-ha patch series avoided such behavior by 
> checking whether the connection between SRP initiator and target is 
> unique, and by removing duplicate SCSI hosts for which the transport 
> layer failed.  Unfortunately these patches are still under review. 
> Unless someone can come up with a better solution I will post a patch 
> one of the next days that makes ib_srp again fail all commands after 
> host removal started. That will avoid spending a long time doing error 
> recovery.
>
> Also, you might have noticed that Hannes Reinecke reported a few days 
> ago that the SCSI error handler may need a lot of time for other 
> transport types - this behavior is not SRP specific.


I'm not sure what to you exactly refer by duplicated SCSI hosts in this 
context or why we have them. Again, at the time we've took the stack 
traces snapshot from the system none of the SCSI EH threads was active, 
so I'm not sure either your comment about spending long time in the 
error recovery flow, as the flow we've run into seems to simply wait 
forever.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
