From: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 00/11] First pass at merging Bart's HA work
Date: Fri, 7 Dec 2012 13:47:14 -0800
Message-ID: <50C263E2.1070805@mellanox.com>
References: <cover.1353903448.git.dillowda@ornl.gov> <CAL1RGDU+b4GxEoY0TOvkyJjr0yx=5tFNmAVZ27hVjOOx=n=yJg@mail.gmail.com> <1353957308.2681.5.camel@dabdike> <1353989041.28917.24.camel@obelisk.thedillows.org> <CAL1RGDXpdWL_r7sWp=vvvXH4jxFgjDL+XcEGgKo-44=wrOBmtA@mail.gmail.com> <1354242098.3670.3.camel@obelisk.thedillows.org> <CAJZOPZJBTRXftrW5NWEEHnf2QWsni0HMTAV_PKSgDtA7GO=wRw@mail.gmail.com> <50BF9760.2080801@acm.org> <CAJZOPZKPs5Vx5nB3610V+byv9p1KvL7+sRU6G4uMTRQu=4=STw@mail.gmail.com> <50C0A76C.20500@acm.org> <50C0AB42.8040402@mellanox.com> <50C0B407.4010706@acm.org> <50C0BFE0.909@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50C0BFE0.909-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Turin <alextu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org" <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, "rcj-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <rcj-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Alex Turin wrote:
> On 12/6/2012 5:04 PM, Bart Van Assche wrote:
>   
>> On 12/06/12 15:27, Or Gerlitz wrote:
>>     
>>> The core problem here seems to be that scsi_remove_host simply never 
>>> ends.
>>>       
>> Hello Or,
>>
>> The later patches in the srp-ha patch series avoided such behavior by 
>> checking whether the connection between SRP initiator and target is 
>> unique, and by removing duplicate SCSI hosts for which the transport 
>> layer failed.  Unfortunately these patches are still under review. 
>> Unless someone can come up with a better solution I will post a patch 
>> one of the next days that makes ib_srp again fail all commands after 
>> host removal started. That will avoid spending a long time doing error 
>> recovery.
>>
>> Also, you might have noticed that Hannes Reinecke reported a few days 
>> ago that the SCSI error handler may need a lot of time for other 
>> transport types - this behavior is not SRP specific.
>>
>> Bart.
>>
>>     
> Hello Bart,
>
> In our case we don't have duplicate hosts or targets. We are working 
> with a single SCSI disk.
> To make scsi_remove_host hang we simply disabling a IB port and run "dd 
> if=/dev/sdb of=/dev/null count=1".
>
>   
Hello Bart,

I applied your latest patch [PATCH for-next] IB/srp: Make SCSI error 
handling finish
and test

Let me capture what I'm seeing:

Host has two paths (scsi_host 7 & 8) to target thru two physical ports 1 & 2

[root@rsws42 ~]# multipath -l
size=50G features='0' hwhandler='0' wp=rw
|-+- policy='round-robin 0' prio=0 status=active
| `- 7:0:0:11 sdb 8:16 active undef running
`-+- policy='round-robin 0' prio=0 status=enabled
  `- 8:0:0:11 sdc 8:32 active undef running

Cable pull by disable port 1, I/Os fail-over fine, the problem is the 
cleaning of scsi_host 7 of fail path.
IB RC failure, scsi error recovery kick in.
srp _reconnect_target() failed, srp_remove_target() run to remove 
scsi_host 7; however, I think it get stuck at device_del(dev) inside 
__scsi_remove_device(dev)

Error recovery continuously happen again and again on scsi host 7 for 
9-10 minutes.
scsi_host 7 cannot be cleaned up, its sysfs entry is still there 
(/sys/class/scsi_host/host7), its state is SHOST_CANCEL.

I brought port 1 back online, scsi_host 7 cannot reconnect to target 
because its state in SRP_TARGET_REMOVED.

scci_host 7 sysfs entry does not contain target login info (ioc_guid, 
id_ext, dgid...).
I think srp_daemon can reconnect to target by creating new path with new 
scsi hosst; however, I cannot check because I currently don't have a 
working srp_daemon.
I need to manually reconnect to target with echo command

Bottom line, I/Os can fail-over/failback; however, old scsi hosts cannot 
be removed (sysfs entry is still there) with state SHOST_CANCEL, error 
recovery keep happening on old scsi hosts for 10-20 minutes.

thanks,
-vu
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
