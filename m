From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: slave_destroy called in scsi_scan.c:scsi_probe_and_add_lun()
Date: Tue, 17 Dec 2002 19:07:34 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <955680000.1040177254@aslan.btc.adaptec.com>
References: <170040000.1040080786@aslan.btc.adaptec.com>
 <20021217054102.GH13989@redhat.com>
 <797140000.1040156703@aslan.btc.adaptec.com>
 <20021217222459.GD28100@redhat.com>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021217222459.GD28100@redhat.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-scsi@vger.kernel.org

> Now, that being said, I agree that the above is utter crap.

Thank you. 8-)

>>  The concern is that
>> the API should only be called when the system is saying "physical device
>> gone", not due to some quirk in how the mid-layer manages its data
>> objects.
> 
> Well, whatever other meaning you want to attach to it, it *is* about data 
> objects.  That's why it's called slave_alloc()/slave_destroy() which are 
> standard object manipulation terms.  One of the reasons I did this was so 
> that in my driver I could yank out a bunch of host structs of the form
> 
> 	unsigned char	queue_depth[MAX_TARGETS][MAX_LUNS};
> 
> and instead add a new struct aic_dev_data that I attach directly to 
> device->hostdata during slave_alloc(), and in that struct aic_dev_data 
> goes *all* the state data needed for that device. It resulted in a not 
> insignificant reduction in memory foot print for the driver.

Well, by dynamically allocating these types of things, and aggregating
them into a single structure instead of a bunch of arrays, I would
expect such a reduction.  The only difference between what your driver
is doing and what mine does is that there is a single static array for
indexing targets.  The rest of the data structures are dynamically allocated
and only live for "real" devices.  The lookup array is a requirement for
supporting 2.4.X.

...

> The secondary use that a  slave_destroy() event can trigger a device
> shutdown sequence in your  driver was a bonus, but because of hokey crap
> in the scsi scan code it's a  bonus that requires you refcount things
> instead of just assuming that a  slave_destroy() is permanent.

I decided to instrument what the SCSI layer does with these calls before
looking at refcounting.  Here's the output of the scan of a bus with
two drives on it: id 0 and id 1.

scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.23
        <Adaptec aic7899 Ultra160 SCSI adapter>
        aic7899: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs

scsi0: Slave Alloc 0
scsi0: Slave Destroy 0
scsi0: Slave Alloc 0
scsi0: Slave Alloc 0
  Vendor: SEAGATE   Model: ST39236LWV        Rev: 0010
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi0: Slave Destroy 0
scsi0: Slave Alloc 0
scsi0: Slave Destroy 1
scsi0: Slave Alloc 1
scsi0: Slave Alloc 1
  Vendor: SEAGATE   Model: ST39236LW         Rev: 0010
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi0: Slave Destroy 1
scsi0: Slave Alloc 1
scsi0: Slave Destroy 2
scsi0: Slave Alloc 2
(scsi0:A:1): 160.000MB/s transfers (80.000MHz DT, offset 31, 16bit)
scsi0: Slave Destroy 3
scsi0: Slave Alloc 3
scsi0: Slave Destroy 4
scsi0: Slave Alloc 4
scsi0: Slave Destroy 5
scsi0: Slave Alloc 5
scsi0: Slave Destroy 6
scsi0: Slave Alloc 6
scsi0: Slave Destroy 8
scsi0: Slave Alloc 8
scsi0: Slave Destroy 9
scsi0: Slave Alloc 9
scsi0: Slave Destroy 10
scsi0: Slave Alloc 10
scsi0: Slave Destroy 11
scsi0: Slave Alloc 11
scsi0: Slave Destroy 12
scsi0: Slave Alloc 12
scsi0: Slave Destroy 13
scsi0: Slave Alloc 13
scsi0: Slave Destroy 14
scsi0: Slave Alloc 14
scsi0: Slave Destroy 15
scsi0: Slave Alloc 15
scsi0: Slave Destroy 15

...

scsi0: Slave Configure 0
scsi0: Slave Configure 1

Notice that for all IDs but 0, a slave destroy call is performed
prior to any slave allocations.  Very nice.  Note that I wasn't
complaining that I couldn't work around this kind of crap, just
that this crap is unsettling. 8-)

> In my driver I don't attempt to do anything like send cache flush
> commands  or the like, so I don't have the shutdown difficulties you do
> and things  work quite nicely.

It's not about cache flushing or anything else.  It's about knowing if
you need to retest the connection to a device, whether or not you should
force a renegotiation the next time a command is attempted to a device,
etc. etc.  So, when linux tells the driver that the device is gone,
we setup our state so that we will not trust the old negotiated values
and will perform Domain Validation again should the device return.

--
Justin
