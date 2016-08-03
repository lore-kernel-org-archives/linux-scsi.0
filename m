From: Laurence Oberman <loberman@redhat.com>
Subject: Re: dm-mq and end_clone_request()
Date: Tue, 2 Aug 2016 21:33:26 -0400 (EDT)
Message-ID: <1101234181.7977273.1470188006882.JavaMail.zimbra@redhat.com>
References: <536022978.7668211.1470060125271.JavaMail.zimbra@redhat.com> <20160801175948.GA6685@redhat.com> <f9e71e1d-54ca-40fe-a5ea-ae2863c94ff9@sandisk.com> <20160801204628.GA94704@redhat.com> <8e265fcc-8021-830e-ffcb-23a8a28ec247@sandisk.com> <20160802174533.GA18714@redhat.com> <1a460c29-1530-d3e1-25ba-736d86aff12e@sandisk.com> <20160803004013.GA19956@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx5-phx2.redhat.com ([209.132.183.37]:46104 "EHLO
	mx5-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045AbcHCBdb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Aug 2016 21:33:31 -0400
In-Reply-To: <20160803004013.GA19956@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org

Hi Bart

I simplified the test to 2 simple scripts and only running against one XFS file system.
Can you validate these and tell me if its enough to emulate what you are doing.
Perhaps our test-suite is too simple.

Start the test

# cat run_test.sh
#!/bin/bash
logger "Starting Bart's test"
#for i in `seq 1 10`
for i in 1
do
	fio --verify=md5 -rw=randwrite --size=10M --bs=4K --loops=$((10**6)) \
        --iodepth=64 --group_reporting --sync=1 --direct=1 --ioengine=libaio \
        --directory="/data-$i" --name=data-integrity-test --thread --numjobs=16 \
        --runtime=600 --output=fio-output.txt >/dev/null &
done

Delete the host, I wait 10s in between host deletions. 
But I also tested with 3s and still its stable with Mike's patches.

#!/bin/bash
for i in /sys/class/srp_remote_ports/*
do
 echo "Deleting host $i, it will re-connect via srp_daemon" 
 echo 1 > $i/delete
 sleep 10
done

Check for I/O errors affecting XFS and we now have none with the patches Mike provided.
After recovery I can create files in the xfs mount with no issues.

Can you use my scripts and 1 mount and see if it still fails for you.

Thanks
Laurence

----- Original Message -----
> From: "Mike Snitzer" <snitzer@redhat.com>
> To: "Bart Van Assche" <bart.vanassche@sandisk.com>
> Cc: dm-devel@redhat.com, "Laurence Oberman" <loberman@redhat.com>, linux-scsi@vger.kernel.org
> Sent: Tuesday, August 2, 2016 8:40:14 PM
> Subject: Re: dm-mq and end_clone_request()
> 
> On Tue, Aug 02 2016 at  8:19pm -0400,
> Bart Van Assche <bart.vanassche@sandisk.com> wrote:
> 
> > On 08/02/2016 10:45 AM, Mike Snitzer wrote:
> > > Please do these same tests against a v4.7 kernel with the 4 patches from
> > > this branch applied (no need for your other debug patches):
> > > https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-4.7-mpath-fixes
> > > 
> > > I've had good results with my blk-mq SRP based testing.
> > 
> > Hello Mike,
> > 
> > Thanks again for having made these patches available. The results of my
> > tests are as follows:
> 
> Disappointing.  But I asked you to run the v4.7 kernel patches I
> pointed to _without_ any of your debug patches.
> 
> I cannot reproduce on our SRP testbed with the fixes I provided.  We're
> now in a place where there would appear to be something very unique to
> your environment causing these failures.
> 
