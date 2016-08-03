From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [dm-devel] dm-mq and end_clone_request()
Date: Wed, 3 Aug 2016 14:03:05 -0400 (EDT)
Message-ID: <1165785378.8091030.1470247385715.JavaMail.zimbra@redhat.com>
References: <536022978.7668211.1470060125271.JavaMail.zimbra@redhat.com> <20160801204628.GA94704@redhat.com> <8e265fcc-8021-830e-ffcb-23a8a28ec247@sandisk.com> <20160802174533.GA18714@redhat.com> <1a460c29-1530-d3e1-25ba-736d86aff12e@sandisk.com> <20160803004013.GA19956@redhat.com> <1101234181.7977273.1470188006882.JavaMail.zimbra@redhat.com> <4b015567-0fdb-dbf5-96e2-627e76b48a03@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:46256 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbcHCSDI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2016 14:03:08 -0400
In-Reply-To: <4b015567-0fdb-dbf5-96e2-627e76b48a03@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org



----- Original Message -----
> From: "Bart Van Assche" <bart.vanassche@sandisk.com>
> To: "Laurence Oberman" <loberman@redhat.com>, "Mike Snitzer" <snitzer@redhat.com>
> Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org
> Sent: Wednesday, August 3, 2016 12:06:17 PM
> Subject: Re: [dm-devel] dm-mq and end_clone_request()
> 
> On 08/02/2016 06:33 PM, Laurence Oberman wrote:
> > #!/bin/bash
> > for i in /sys/class/srp_remote_ports/*
> > do
> >  echo "Deleting host $i, it will re-connect via srp_daemon"
> >  echo 1 > $i/delete
> >  sleep 10
> > done
> 
> Hello Laurence,
> 
> Sorry but the above looks wrong to me. There should be a second loop
> around this loop and the sleep statement should be moved from the inner
> loop to the outer loop. The above code logs out one (initiator, target)
> port pair at a time instead of logging out all paths at once.
> 
> Bart.
> 

Hi Bart

Latest tests are still good on our side.
I am now taking both paths out at the same time but still we seem stable here.
First test removed sleep and we still had a delay, second test add a background so they ran as close as possible to the same time.
Both tests passed.

I will email messages log just to you.

With no sleep we still have a gap when we delete paths of 9s and we are good.

Aug  3 13:41:21 jumpclient multipathd: 360001ff0b035d000000000008d700001: remaining active paths: 1
Aug  3 13:41:22 jumpclient multipathd: 360001ff0b035d000000000028d720003: remaining active paths: 1
Aug  3 13:41:22 jumpclient multipathd: 360001ff0b035d000000000048d740005: remaining active paths: 1
Aug  3 13:41:22 jumpclient multipathd: 360001ff0b035d000000000068d760007: remaining active paths: 1
Aug  3 13:41:23 jumpclient multipathd: 360001ff0b035d0000000000b8d7b000c: remaining active paths: 1
Aug  3 13:41:23 jumpclient multipathd: 360001ff0b035d0000000000d8d7d000e: remaining active paths: 1
Aug  3 13:41:23 jumpclient multipathd: 360001ff0b035d000000000118d810012: remaining active paths: 1
Aug  3 13:41:24 jumpclient multipathd: 360001ff0b035d000000000138d830014: remaining active paths: 1
Aug  3 13:41:24 jumpclient multipathd: 360001ff0b035d000000000158d850016: remaining active paths: 1
Aug  3 13:41:25 jumpclient multipathd: 360001ff0b035d000000000178d870018: remaining active paths: 1
Aug  3 13:41:25 jumpclient multipathd: 360001ff0b035d000000000198d89001a: remaining active paths: 1
Aug  3 13:41:25 jumpclient multipathd: 360001ff0b035d0000000001a8d8a001b: remaining active paths: 1
Aug  3 13:41:25 jumpclient multipathd: 360001ff0b035d0000000001c8d8c001d: remaining active paths: 1
Aug  3 13:41:26 jumpclient multipathd: 360001ff0b035d0000000001e8d8e001f: remaining active paths: 1
Aug  3 13:41:26 jumpclient multipathd: 360001ff0b035d0000000001f8d8f0020: remaining active paths: 1
Aug  3 13:41:26 jumpclient multipathd: 360001ff0b035d000000000208d900021: remaining active paths: 1
Aug  3 13:41:26 jumpclient multipathd: 360001ff0b035d000000000228d920023: remaining active paths: 1
Aug  3 13:41:28 jumpclient multipathd: 360001ff0b035d000000000248d940025: remaining active paths: 1
Aug  3 13:41:29 jumpclient multipathd: 360001ff0b035d000000000268d960027: remaining active paths: 1
Aug  3 13:41:29 jumpclient multipathd: 360001ff0b035d000000000278d970028: remaining active paths: 1
Aug  3 13:41:30 jumpclient multipathd: 360001ff0b035d000000000288d980029: remaining active paths: 1
Aug  3 13:41:35 jumpclient multipathd: 360001ff0b035d000000000008d700001: remaining active paths: 0
Aug  3 13:41:36 jumpclient multipathd: 360001ff0b035d000000000028d720003: remaining active paths: 0
Aug  3 13:41:37 jumpclient multipathd: 360001ff0b035d000000000048d740005: remaining active paths: 0
Aug  3 13:41:37 jumpclient multipathd: 360001ff0b035d000000000068d760007: remaining active paths: 0
Aug  3 13:41:38 jumpclient multipathd: 360001ff0b035d0000000000b8d7b000c: remaining active paths: 0
Aug  3 13:41:38 jumpclient multipathd: 360001ff0b035d0000000000d8d7d000e: remaining active paths: 0
Aug  3 13:41:38 jumpclient multipathd: 360001ff0b035d000000000108d800011: remaining active paths: 0
Aug  3 13:41:38 jumpclient multipathd: 360001ff0b035d000000000118d810012: remaining active paths: 0
Aug  3 13:41:38 jumpclient multipathd: 360001ff0b035d000000000138d830014: remaining active paths: 0
Aug  3 13:41:39 jumpclient multipathd: 360001ff0b035d000000000158d850016: remaining active paths: 0
Aug  3 13:41:39 jumpclient multipathd: 360001ff0b035d000000000178d870018: remaining active paths: 0
Aug  3 13:41:39 jumpclient multipathd: 360001ff0b035d000000000198d89001a: remaining active paths: 0
Aug  3 13:41:39 jumpclient multipathd: 360001ff0b035d0000000001a8d8a001b: remaining active paths: 0
Aug  3 13:41:39 jumpclient multipathd: 360001ff0b035d0000000001c8d8c001d: remaining active paths: 0
Aug  3 13:41:39 jumpclient multipathd: 360001ff0b035d0000000001e8d8e001f: remaining active paths: 0
Aug  3 13:41:41 jumpclient multipathd: 360001ff0b035d0000000001f8d8f0020: remaining active paths: 0
Aug  3 13:41:41 jumpclient multipathd: 360001ff0b035d000000000208d900021: remaining active paths: 0
Aug  3 13:41:43 jumpclient multipathd: 360001ff0b035d000000000248d940025: remaining active paths: 0
Aug  3 13:41:43 jumpclient multipathd: 360001ff0b035d000000000268d960027: remaining active paths: 0
Aug  3 13:41:44 jumpclient multipathd: 360001ff0b035d000000000288d980029: remaining active paths: 0
Aug  3 13:42:44 jumpclient multipathd: 360001ff0b035d000000000138d830014: remaining active paths: 2
Aug  3 13:42:44 jumpclient multipathd: 360001ff0b035d000000000158d850016: remaining active paths: 2

These are the only errors and they are expected.

Aug  3 13:41:22 jumpclient kernel: blk_update_request: I/O error, dev sdd, sector 31141264880
Aug  3 13:41:22 jumpclient kernel: blk_update_request: I/O error, dev sdd, sector 79928
Aug  3 13:41:22 jumpclient kernel: blk_update_request: I/O error, dev sdd, sector 65264
Aug  3 13:41:22 jumpclient kernel: blk_update_request: I/O error, dev sdd, sector 55232
Aug  3 13:41:22 jumpclient kernel: blk_update_request: I/O error, dev sdd, sector 14152
Aug  3 13:41:22 jumpclient kernel: blk_update_request: I/O error, dev sdd, sector 168880
Aug  3 13:41:22 jumpclient kernel: blk_update_request: I/O error, dev sdd, sector 269392
Aug  3 13:41:22 jumpclient kernel: blk_update_request: I/O error, dev sdd, sector 309200
Aug  3 13:41:22 jumpclient kernel: blk_update_request: I/O error, dev sdd, sector 87520
Aug  3 13:41:22 jumpclient kernel: blk_update_request: I/O error, dev sdd, sector 7744
Aug  3 13:41:28 jumpclient kernel: blk_update_request: I/O error, dev sdca, sector 119984
Aug  3 13:41:29 jumpclient kernel: blk_update_request: I/O error, dev sdcd, sector 31139908984
Aug  3 13:41:29 jumpclient kernel: blk_update_request: I/O error, dev sdcd, sector 131136
Aug  3 13:41:29 jumpclient kernel: blk_update_request: I/O error, dev sdcd, sector 97536
Aug  3 13:41:29 jumpclient kernel: blk_update_request: I/O error, dev sdcd, sector 123264
Aug  3 13:41:29 jumpclient kernel: blk_update_request: I/O error, dev sdcd, sector 110336
Aug  3 13:41:29 jumpclient kernel: blk_update_request: I/O error, dev sdcd, sector 158136
Aug  3 13:41:29 jumpclient kernel: blk_update_request: I/O error, dev sdcd, sector 156136
Aug  3 13:41:29 jumpclient kernel: blk_update_request: I/O error, dev sdcd, sector 173072
Aug  3 13:41:29 jumpclient kernel: blk_update_request: I/O error, dev sdcd, sector 6984
Aug  3 13:41:35 jumpclient kernel: blk_update_request: I/O error, dev sdc, sector 130224
Aug  3 13:41:35 jumpclient kernel: blk_update_request: I/O error, dev sdc, sector 225816
Aug  3 13:41:36 jumpclient kernel: blk_update_request: I/O error, dev sdc, sector 248120
Aug  3 13:41:36 jumpclient kernel: blk_update_request: I/O error, dev sdc, sector 242528
Aug  3 13:41:36 jumpclient kernel: blk_update_request: I/O error, dev sdk, sector 251248
Aug  3 13:41:36 jumpclient kernel: blk_update_request: I/O error, dev sdk, sector 242032
Aug  3 13:41:36 jumpclient kernel: blk_update_request: I/O error, dev sdk, sector 203736
Aug  3 13:41:36 jumpclient kernel: blk_update_request: I/O error, dev sdk, sector 31141107808
Aug  3 13:41:36 jumpclient kernel: blk_update_request: I/O error, dev sdk, sector 233336
Aug  3 13:41:36 jumpclient kernel: blk_update_request: I/O error, dev sdk, sector 187944
Aug  3 13:41:41 jumpclient kernel: blk_update_request: I/O error, dev sdbl, sector 85800
Aug  3 13:41:41 jumpclient kernel: blk_update_request: I/O error, dev sdbl, sector 74120
Aug  3 13:41:41 jumpclient kernel: blk_update_request: I/O error, dev sdbl, sector 78216
Aug  3 13:41:41 jumpclient kernel: blk_update_request: I/O error, dev sdbl, sector 79976
Aug  3 13:41:41 jumpclient kernel: blk_update_request: I/O error, dev sdbl, sector 79552
Aug  3 13:41:41 jumpclient kernel: blk_update_request: I/O error, dev sdbl, sector 87888
Aug  3 13:41:43 jumpclient kernel: blk_update_request: I/O error, dev sdbt, sector 274368
Aug  3 13:41:43 jumpclient kernel: blk_update_request: I/O error, dev sdbt, sector 31139814080
Aug  3 13:41:43 jumpclient kernel: blk_update_request: I/O error, dev sdbx, sector 6776
Aug  3 13:41:43 jumpclient kernel: blk_update_request: I/O error, dev sdbx, sector 302152

Changing script to add & we take both away at the same time but still we seem to survive here.

This is my configuration:

360001ff0b035d000000000078d770008 dm-9 DDN     ,SFA14K          
size=29T features='3 queue_if_no_path queue_mode mq' hwhandler='0' wp=rw
|-+- policy='round-robin 0' prio=90 status=active
| `- 1:0:0:7  sday 67:32  active ready running
`-+- policy='round-robin 0' prio=10 status=enabled
  `- 2:0:0:7  sdj  8:144  active ready running

       device {
        vendor                  "DDN"
        product                 "SFA14K"
        path_grouping_policy    group_by_prio
        prio                    alua
        path_selector           "round-robin 0"
        path_checker            tur
        failback                2
        rr_weight               uniform
        no_path_retry           12
        dev_loss_tmo            10
        fast_io_fail_tmo        5
	features     "1 queue_if_no_path"
    }


With &

#!/bin/bash
for i in /sys/class/srp_remote_ports/*
do
 echo "Deleting host $i, it will re-connect via srp_daemon" 
 echo 1 > $i/delete &
 #sleep 3
done

Here we lose both paths at the same time.

[root@jumpclient bart_tests]# grep remaining messages
Aug  3 13:49:38 jumpclient multipathd: 360001ff0b035d000000000008d700001: remaining active paths: 0
Aug  3 13:49:38 jumpclient multipathd: 360001ff0b035d000000000028d720003: remaining active paths: 0
Aug  3 13:49:38 jumpclient multipathd: 360001ff0b035d000000000048d740005: remaining active paths: 0
Aug  3 13:49:41 jumpclient multipathd: 360001ff0b035d000000000068d760007: remaining active paths: 0
Aug  3 13:49:42 jumpclient multipathd: 360001ff0b035d0000000000d8d7d000e: remaining active paths: 0
Aug  3 13:49:45 jumpclient multipathd: 360001ff0b035d000000000118d810012: remaining active paths: 0
Aug  3 13:49:45 jumpclient multipathd: 360001ff0b035d000000000108d800011: remaining active paths: 0
Aug  3 13:49:47 jumpclient multipathd: 360001ff0b035d000000000158d850016: remaining active paths: 0
Aug  3 13:49:48 jumpclient multipathd: 360001ff0b035d000000000178d870018: remaining active paths: 0
Aug  3 13:49:48 jumpclient multipathd: 360001ff0b035d000000000198d89001a: remaining active paths: 0
Aug  3 13:49:48 jumpclient multipathd: 360001ff0b035d0000000001a8d8a001b: remaining active paths: 0
Aug  3 13:49:55 jumpclient multipathd: 360001ff0b035d0000000001e8d8e001f: remaining active paths: 0
Aug  3 13:49:55 jumpclient multipathd: 360001ff0b035d0000000001f8d8f0020: remaining active paths: 0
Aug  3 13:49:58 jumpclient multipathd: 360001ff0b035d000000000248d940025: remaining active paths: 0
Aug  3 13:49:59 jumpclient multipathd: 360001ff0b035d000000000268d960027: remaining active paths: 0
Aug  3 13:50:00 jumpclient multipathd: 360001ff0b035d000000000288d980029: remaining active paths: 0
Aug  3 13:51:17 jumpclient multipathd: 360001ff0b035d000000000038d730004: remaining active paths: 2
Aug  3 13:51:17 jumpclient multipathd: 360001ff0b035d000000000028d720003: remaining active paths: 2
Aug  3 13:51:19 jumpclient multipathd: 360001ff0b035d000000000078d770008: remaining active paths: 2
Aug  3 13:51:20 jumpclient multipathd: 360001ff0b035d0000000000a8d7a000b: remaining active paths: 2
Aug  3 13:51:23 jumpclient multipathd: 360001ff0b035d0000000000d8d7d000e: remaining active paths: 2
Aug  3 13:51:24 jumpclient multipathd: 360001ff0b035d000000000108d800011: remaining active paths: 2
Aug  3 13:51:25 jumpclient multipathd: 360001ff0b035d0000000000f8d7f0010: remaining active paths: 2
Aug  3 13:51:26 jumpclient multipathd: 360001ff0b035d000000000128d820013: remaining active paths: 2
Aug  3 13:51:29 jumpclient multipathd: 360001ff0b035d0000000001c8d8c001d: remaining active paths: 2
Aug  3 13:51:33 jumpclient multipathd: 360001ff0b035d000000000228d920023: remaining active paths: 2
Aug  3 13:51:34 jumpclient multipathd: 360001ff0b035d000000000238d930024: remaining active paths: 2

We still survive.

[root@jumpclient bart_tests]# grep -i error messages
Aug  3 13:49:38 jumpclient kernel: blk_update_request: I/O error, dev sdc, sector 98288
Aug  3 13:49:38 jumpclient kernel: blk_update_request: I/O error, dev sdc, sector 98320
Aug  3 13:49:38 jumpclient kernel: blk_update_request: I/O error, dev sdc, sector 46976
Aug  3 13:49:38 jumpclient kernel: blk_update_request: I/O error, dev sde, sector 216720
Aug  3 13:49:38 jumpclient kernel: blk_update_request: I/O error, dev sdg, sector 130672
Aug  3 13:49:41 jumpclient kernel: blk_update_request: I/O error, dev sdi, sector 56984
Aug  3 13:49:41 jumpclient kernel: blk_update_request: I/O error, dev sdi, sector 56120
Aug  3 13:49:41 jumpclient kernel: blk_update_request: I/O error, dev sdi, sector 62112
Aug  3 13:49:42 jumpclient kernel: blk_update_request: I/O error, dev sdp, sector 156944
Aug  3 13:49:42 jumpclient kernel: blk_update_request: I/O error, dev sdp, sector 31140975496
Aug  3 13:49:44 jumpclient kernel: blk_update_request: I/O error, dev sdt, sector 207392
Aug  3 13:49:44 jumpclient kernel: blk_update_request: I/O error, dev sdt, sector 200568
Aug  3 13:49:44 jumpclient kernel: blk_update_request: I/O error, dev sdt, sector 251048
Aug  3 13:49:44 jumpclient kernel: blk_update_request: I/O error, dev sdt, sector 247616
Aug  3 13:49:44 jumpclient kernel: blk_update_request: I/O error, dev sdt, sector 210592
Aug  3 13:49:44 jumpclient kernel: blk_update_request: I/O error, dev sdt, sector 200120
Aug  3 13:49:44 jumpclient kernel: blk_update_request: I/O error, dev sdt, sector 203000
Aug  3 13:49:44 jumpclient kernel: blk_update_request: I/O error, dev sdt, sector 248640
Aug  3 13:49:47 jumpclient kernel: blk_update_request: I/O error, dev sdx, sector 48232
Aug  3 13:49:48 jumpclient kernel: blk_update_request: I/O error, dev sdz, sector 9984
Aug  3 13:49:55 jumpclient kernel: blk_update_request: I/O error, dev sdag, sector 130512
Aug  3 13:49:58 jumpclient kernel: blk_update_request: I/O error, dev sdai, sector 39040
Aug  3 13:49:58 jumpclient kernel: blk_update_request: I/O error, dev sdam, sector 31140570528
Aug  3 13:49:59 jumpclient kernel: blk_update_request: I/O error, dev sdao, sector 204552
Aug  3 13:50:00 jumpclient kernel: blk_update_request: I/O error, dev sdaq, sector 31142052904



