From: Laurence Oberman <loberman@redhat.com>
Subject: Re: dm-mq and end_clone_request()
Date: Tue, 2 Aug 2016 22:55:59 -0400 (EDT)
Message-ID: <766674512.7979990.1470192959236.JavaMail.zimbra@redhat.com>
References: <536022978.7668211.1470060125271.JavaMail.zimbra@redhat.com>
	<8e265fcc-8021-830e-ffcb-23a8a28ec247@sandisk.com>
	<20160802174533.GA18714@redhat.com>
	<1a460c29-1530-d3e1-25ba-736d86aff12e@sandisk.com>
	<20160803004013.GA19956@redhat.com>
	<1101234181.7977273.1470188006882.JavaMail.zimbra@redhat.com>
	<20160803021012.GA21383@redhat.com>
	<1221150553.7978667.1470190710829.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1221150553.7978667.1470190710829.JavaMail.zimbra@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



----- Original Message -----
> From: "Laurence Oberman" <loberman@redhat.com>
> To: "Mike Snitzer" <snitzer@redhat.com>
> Cc: "Bart Van Assche" <bart.vanassche@sandisk.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org
> Sent: Tuesday, August 2, 2016 10:18:30 PM
> Subject: Re: dm-mq and end_clone_request()
> 
> 
> 
> ----- Original Message -----
> > From: "Mike Snitzer" <snitzer@redhat.com>
> > To: "Laurence Oberman" <loberman@redhat.com>
> > Cc: "Bart Van Assche" <bart.vanassche@sandisk.com>, dm-devel@redhat.com,
> > linux-scsi@vger.kernel.org
> > Sent: Tuesday, August 2, 2016 10:10:12 PM
> > Subject: Re: dm-mq and end_clone_request()
> > 
> > On Tue, Aug 02 2016 at  9:33pm -0400,
> > Laurence Oberman <loberman@redhat.com> wrote:
> > 
> > > Hi Bart
> > > 
> > > I simplified the test to 2 simple scripts and only running against one
> > > XFS
> > > file system.
> > > Can you validate these and tell me if its enough to emulate what you are
> > > doing.
> > > Perhaps our test-suite is too simple.
> > > 
> > > Start the test
> > > 
> > > # cat run_test.sh
> > > #!/bin/bash
> > > logger "Starting Bart's test"
> > > #for i in `seq 1 10`
> > > for i in 1
> > > do
> > > 	fio --verify=md5 -rw=randwrite --size=10M --bs=4K --loops=$((10**6)) \
> > >         --iodepth=64 --group_reporting --sync=1 --direct=1
> > >         --ioengine=libaio \
> > >         --directory="/data-$i" --name=data-integrity-test --thread
> > >         --numjobs=16 \
> > >         --runtime=600 --output=fio-output.txt >/dev/null &
> > > done
> > > 
> > > Delete the host, I wait 10s in between host deletions.
> > > But I also tested with 3s and still its stable with Mike's patches.
> > > 
> > > #!/bin/bash
> > > for i in /sys/class/srp_remote_ports/*
> > > do
> > >  echo "Deleting host $i, it will re-connect via srp_daemon"
> > >  echo 1 > $i/delete
> > >  sleep 10
> > > done
> > > 
> > > Check for I/O errors affecting XFS and we now have none with the patches
> > > Mike provided.
> > > After recovery I can create files in the xfs mount with no issues.
> > > 
> > > Can you use my scripts and 1 mount and see if it still fails for you.
> > 
> > In parallel we can try Bart's testsuite that he shared earlier in this
> > thread: https://github.com/bvanassche/srp-test
> > 
> > README.md says:
> > "Running these tests manually is tedious. Hence this test suite that
> > tests the SRP initiator and target drivers by loading both drivers on
> > the same server, by logging in using the IB loopback functionality and
> > by sending I/O through the SRP initiator driver to a RAM disk exported
> > by the SRP target driver."
> > 
> > This could explain why Bart is still seeing issues.  He isn't testing
> > real hardware -- as such he is using ramdisk to expose races, etc.
> > 
> > Mike
> > 
> 
> Hi Mike,
> 
> I looked at Bart's scripts, they looked fine but I wanted a more simplified
> way to bring the error out.
> Using ramdisk is not uncommon as an LIO backend via ib_srpt to serve LUNS.
> That is the same way I do it when I am not connected to a large array as it
> is the only way I can get EDR like speeds.
> 
> I don't thinks its racing due to the ramdisk back-end but  maybe we need to
> ramp ours up to run more in parallel in a loop.
> 
> I will run 21 parallel runs and see if it makes a difference tonight and
> report back tomorrow.
> Clearly prior to your final patches we were escaping back to the FS layer
> with errors but since your patches, at least in out test harness that is
> resolved.
> 
> Thanks
> Laurence
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Hello

I ran 20 parallel runs with 3 loops through host deletion and in each case fio survived with no hard error escaping to the FS layer.
Its solid in our test bed,
Keep in mind we have no ib_srpt loaded as we have a hardware based array and are connected directly to the array with EDR 100.
I am also not removing and reloading modules like is happening in Barts's scripts and also not trying to delete mpath maps etc.

I focused only on the I/O error that was escaping up to the FS layer.
I will check in with Bart tomorrow.

Thanks
Laurence
