From: Laurence Oberman <loberman@redhat.com>
Subject: Re: dm-mq and end_clone_request()
Date: Wed, 3 Aug 2016 11:10:14 -0400 (EDT)
Message-ID: <114076006.8072270.1470237014051.JavaMail.zimbra@redhat.com>
References: <536022978.7668211.1470060125271.JavaMail.zimbra@redhat.com> <20160802174533.GA18714@redhat.com> <1a460c29-1530-d3e1-25ba-736d86aff12e@sandisk.com> <20160803004013.GA19956@redhat.com> <1101234181.7977273.1470188006882.JavaMail.zimbra@redhat.com> <20160803021012.GA21383@redhat.com> <1221150553.7978667.1470190710829.JavaMail.zimbra@redhat.com> <766674512.7979990.1470192959236.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:39426 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757683AbcHCPKR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2016 11:10:17 -0400
In-Reply-To: <766674512.7979990.1470192959236.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org



----- Original Message -----
> From: "Laurence Oberman" <loberman@redhat.com>
> To: "Mike Snitzer" <snitzer@redhat.com>
> Cc: "Bart Van Assche" <bart.vanassche@sandisk.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org
> Sent: Tuesday, August 2, 2016 10:55:59 PM
> Subject: Re: dm-mq and end_clone_request()
> 
> 
> 
> ----- Original Message -----
> > From: "Laurence Oberman" <loberman@redhat.com>
> > To: "Mike Snitzer" <snitzer@redhat.com>
> > Cc: "Bart Van Assche" <bart.vanassche@sandisk.com>, dm-devel@redhat.com,
> > linux-scsi@vger.kernel.org
> > Sent: Tuesday, August 2, 2016 10:18:30 PM
> > Subject: Re: dm-mq and end_clone_request()
> > 
> > 
> > 
> > ----- Original Message -----
> > > From: "Mike Snitzer" <snitzer@redhat.com>
> > > To: "Laurence Oberman" <loberman@redhat.com>
> > > Cc: "Bart Van Assche" <bart.vanassche@sandisk.com>, dm-devel@redhat.com,
> > > linux-scsi@vger.kernel.org
> > > Sent: Tuesday, August 2, 2016 10:10:12 PM
> > > Subject: Re: dm-mq and end_clone_request()
> > > 
> > > On Tue, Aug 02 2016 at  9:33pm -0400,
> > > Laurence Oberman <loberman@redhat.com> wrote:
> > > 
> > > > Hi Bart
> > > > 
> > > > I simplified the test to 2 simple scripts and only running against one
> > > > XFS
> > > > file system.
> > > > Can you validate these and tell me if its enough to emulate what you
> > > > are
> > > > doing.
> > > > Perhaps our test-suite is too simple.
> > > > 
> > > > Start the test
> > > > 
> > > > # cat run_test.sh
> > > > #!/bin/bash
> > > > logger "Starting Bart's test"
> > > > #for i in `seq 1 10`
> > > > for i in 1
> > > > do
> > > > 	fio --verify=md5 -rw=randwrite --size=10M --bs=4K --loops=$((10**6)) \
> > > >         --iodepth=64 --group_reporting --sync=1 --direct=1
> > > >         --ioengine=libaio \
> > > >         --directory="/data-$i" --name=data-integrity-test --thread
> > > >         --numjobs=16 \
> > > >         --runtime=600 --output=fio-output.txt >/dev/null &
> > > > done
> > > > 
> > > > Delete the host, I wait 10s in between host deletions.
> > > > But I also tested with 3s and still its stable with Mike's patches.
> > > > 
> > > > #!/bin/bash
> > > > for i in /sys/class/srp_remote_ports/*
> > > > do
> > > >  echo "Deleting host $i, it will re-connect via srp_daemon"
> > > >  echo 1 > $i/delete
> > > >  sleep 10
> > > > done
> > > > 
> > > > Check for I/O errors affecting XFS and we now have none with the
> > > > patches
> > > > Mike provided.
> > > > After recovery I can create files in the xfs mount with no issues.
> > > > 
> > > > Can you use my scripts and 1 mount and see if it still fails for you.
> > > 
> > > In parallel we can try Bart's testsuite that he shared earlier in this
> > > thread: https://github.com/bvanassche/srp-test
> > > 
> > > README.md says:
> > > "Running these tests manually is tedious. Hence this test suite that
> > > tests the SRP initiator and target drivers by loading both drivers on
> > > the same server, by logging in using the IB loopback functionality and
> > > by sending I/O through the SRP initiator driver to a RAM disk exported
> > > by the SRP target driver."
> > > 
> > > This could explain why Bart is still seeing issues.  He isn't testing
> > > real hardware -- as such he is using ramdisk to expose races, etc.
> > > 
> > > Mike
> > > 
> > 
> > Hi Mike,
> > 
> > I looked at Bart's scripts, they looked fine but I wanted a more simplified
> > way to bring the error out.
> > Using ramdisk is not uncommon as an LIO backend via ib_srpt to serve LUNS.
> > That is the same way I do it when I am not connected to a large array as it
> > is the only way I can get EDR like speeds.
> > 
> > I don't thinks its racing due to the ramdisk back-end but  maybe we need to
> > ramp ours up to run more in parallel in a loop.
> > 
> > I will run 21 parallel runs and see if it makes a difference tonight and
> > report back tomorrow.
> > Clearly prior to your final patches we were escaping back to the FS layer
> > with errors but since your patches, at least in out test harness that is
> > resolved.
> > 
> > Thanks
> > Laurence
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> Hello
> 
> I ran 20 parallel runs with 3 loops through host deletion and in each case
> fio survived with no hard error escaping to the FS layer.
> Its solid in our test bed,
> Keep in mind we have no ib_srpt loaded as we have a hardware based array and
> are connected directly to the array with EDR 100.
> I am also not removing and reloading modules like is happening in Barts's
> scripts and also not trying to delete mpath maps etc.
> 
> I focused only on the I/O error that was escaping up to the FS layer.
> I will check in with Bart tomorrow.
> 
> Thanks
> Laurence
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Hi Bart

Looking back at your email.

I also get these, but those are expected as we are in the process of doing I/O when we yank the hosts and that has in-flights affected.

Aug  2 22:41:23 jumpclient kernel: device-mapper: multipath: Failing path 8:192.
Aug  2 22:41:23 jumpclient kernel: blk_update_request: I/O error, dev sdm, sector 258504
Aug  2 22:41:23 jumpclient kernel: blk_update_request: I/O error, dev sdm, sector 60320

However I never get any of these any more (with the patches applied) that you show:
[  162.903284] Buffer I/O error on dev dm-0, logical block 32928, lost sync page write

I will work with you to understand why with Mike's patches, its now stable here but not in your configuration

Thanks
Laurence
