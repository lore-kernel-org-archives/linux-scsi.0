From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: 3.4.0-02580-g72c04af regression on sparc64 - partitions not recognized
Date: Thu, 24 May 2012 00:54:39 -0700
Message-ID: <CABE8wwtr3Qgkvfjpk0ooe+vKvN3H9StMtSUuvyXpe5e-jTG7oA@mail.gmail.com>
References: <alpine.SOC.1.00.1205221200050.9585@math.ut.ee>
	<20120522.151217.278388169416093561.davem@davemloft.net>
	<alpine.SOC.1.00.1205231945480.12326@math.ut.ee>
	<20120523.140451.386112705611304887.davem@davemloft.net>
	<1337813770.3013.37.camel@dabdike.int.hansenpartnership.com>
	<1337826142.6877.7.camel@dwillia2-mobl>
	<1337845361.2955.6.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1337845361.2955.6.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jejbbe@hansenpartnership.com>
Cc: David Miller <davem@davemloft.net>, mroos@linux.ee, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, stern@rowland.harvard.edu, "Rafael J. Wysocki" <rjw@sisk.pl>, Arjan van de Ven <arjan@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, May 24, 2012 at 12:42 AM, James Bottomley
<jejbbe@hansenpartnership.com> wrote:
> On Wed, 2012-05-23 at 19:22 -0700, Dan Williams wrote:
>> On Wed, 2012-05-23 at 23:56 +0100, James Bottomley wrote:
>> > On Wed, 2012-05-23 at 14:04 -0400, David Miller wrote:
>> > > From: Meelis Roos <mroos@linux.ee>
>> > > Date: Wed, 23 May 2012 19:46:46 +0300 (EEST)
>> > >
>> > > CC:'ing interested parties.
>> > >
>> > > >> > Just tested 3.4.0-02580-g72c04af on about 10 machines. Whil=
e most of
>> > > >> > them work (including 3 different sparc64 machines with real=
 scsi disks),
>> > > >> > Sun Netra X1 with pata_ali and IDE disk consistently fails =
to boot. sda
>> > > >> > is recognized but no partitions. 3.3.0 works fine, as did s=
omething
>> > > >> > around 3.4-rc7 (plain 3.4 not tested yet). No other IDE mac=
hines tested
>> > > >> > yet since I have none with remote console at the moment.
>> > > >>
>> > > >> If 3.4.0-final is OK, start bisecting from v3.4.0 until 72c04=
af. =A0One
>> > > >> possibility could be the sparc64 NOBOOTMEM conversion that we=
nt into
>> > > >> the merge window.
>> > > >
>> > > > Bisecting leads to this commit:
>> > > >
>> > > > a7a20d103994fd760766e6c9d494daa569cbfe06 is the first bad comm=
it
>> > > > commit a7a20d103994fd760766e6c9d494daa569cbfe06
>> > > > Author: Dan Williams <dan.j.williams@intel.com>
>> > > > Date: =A0 Thu Mar 22 17:05:11 2012 -0700
>> > > >
>> > > > =A0 =A0 [SCSI] sd: limit the scope of the async probe domain
>> >
>> > My theory is that this is an init problem: The assumption in a lot=
 of
>> > our code is that async_synchronize_full() waits for everything ...=
 even
>> > the domain specific async schedules, which isn't true.
>> >
>> > The code in init that makes this assumption is wait_for_device_pro=
be().
>> > There's also a fun async_synchronize_full() in init_post() that as=
sumes
>> > it can free the init memory after, which would fail badly if anyth=
ing in
>> > init used an async domain.
>> >
>> > So either we fix the assumptions or we can't use domain specific a=
sync
>> > schedules.
>> >
>>
>> Hm, we already have cases of code not trusting the semantics of
>> wait_for_device_probe(), especially as it relates to async scanning =
like
>> in kernel/power/hibernate.c:
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Some device discovery might sti=
ll be in progress; we need
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* to wait for this to finish.
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wait_for_device_probe();
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (resume_wait) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 while ((swsusp_resum=
e_device =3D name_to_dev_t(resume_file)) =3D=3D 0)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 msle=
ep(10);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 async_synchronize_fu=
ll();
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* We can't depend on SCSI devices=
 being available after loading
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* one of their modules until scsi=
_complete_async_scans() is
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* called and the resume device us=
ually is a SCSI one.
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 scsi_complete_async_scans();
>
> This is actually looks wrong: it works if SCSI is built in, but it's =
a
> nop if SCSI is a module (the nop function is gated by the else clause=
 of
> #ifdef CONFIG_SCSI)
>
> Rafael, you added this not via the SCSI tree, is that the intention?
>
>> ...so it seems scsi_complete_async_scans() should take care to flush=
 sd
>> probe actions as well... here is a test patch:
>>
>> --- snip ---
>>
>> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
>> index 8906557..05a92d3 100644
>> --- a/drivers/scsi/scsi_scan.c
>> +++ b/drivers/scsi/scsi_scan.c
>> @@ -141,13 +141,13 @@ struct async_scan_data {
>> =A0 * started scanning after this function was called may or may not=
 have
>> =A0 * finished.
>> =A0 */
>> -int scsi_complete_async_scans(void)
>> +static void __scsi_complete_async_scans(void)
>> =A0{
>> =A0 =A0 =A0 =A0 struct async_scan_data *data;
>>
>> =A0 =A0 =A0 =A0 do {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (list_empty(&scanning_hosts))
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* If we can't get memory immediatel=
y, that's OK. =A0Just
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* sleep a little. =A0Even if we n=
ever get memory, the async
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* scans will finish eventually.
>> @@ -181,6 +181,13 @@ int scsi_complete_async_scans(void)
>> =A0 =A0 =A0 =A0 spin_unlock(&async_scan_lock);
>>
>> =A0 =A0 =A0 =A0 kfree(data);
>> +}
>> +
>> +int scsi_complete_async_scans(void)
>> +{
>> + =A0 =A0 =A0 __scsi_complete_async_scans();
>> + =A0 =A0 =A0 async_synchronize_full_domain(&scsi_sd_probe_domain);
>> +
>> =A0 =A0 =A0 =A0 return 0;
>> =A0}
>
> But this still doesn't fix the boot problem, does it? ... unless we w=
ant
> to add a scsi_complete_async_scans() into init/do_mounts.c, which loo=
ks
> like piling one hack on top of another.

I managed to convince myself that one in prepare_namespace() was
probably not needed because of the late_initcall of
scsi_complete_async_scans() in the built-in case and in the module
case the initramfs should be taking care of it.

> I really think the correct fix is to have wait_for_device_probe()
> actually wait until all probes have completed and everything is
> discovered, that way we get the semantics the name implies and boot
> should just work.
>

=2E..but wouldn't it need to go something like:

wait_for_device_probe(); /* all pci drivers probed */
scsi_complete_async_scans(): /* flush host scans */
wait_for_device_probe(); /* all recently attached sd devices probed */

?

--
Dan
