From: Eric Wagar <eric@deadhookers.org>
Subject: Re: RH9 upgrade to FC3 fails with Adaptec I2O ZCR raid
Date: Sat, 04 Jun 2005 09:16:58 -0700
Message-ID: <42A1D3FA.5020005@deadhookers.org>
References: <429F60A2.1090207@deadhookers.org>
	<42A02C1B.5090802@shadowconnect.com>
	<1117808993.27140.235579224@webmail.messagingengine.com>
	<42A07EF3.6090907@shadowconnect.com>
Reply-To: For users of Fedora Core releases <fedora-list@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <fedora-list-bounces@redhat.com>
In-Reply-To: <42A07EF3.6090907@shadowconnect.com>
List-Unsubscribe: <http://www.redhat.com/mailman/listinfo/fedora-list>,
	<mailto:fedora-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/fedora-list>
List-Post: <mailto:fedora-list@redhat.com>
List-Help: <mailto:fedora-list-request@redhat.com?subject=help>
List-Subscribe: <http://www.redhat.com/mailman/listinfo/fedora-list>,
	<mailto:fedora-list-request@redhat.com?subject=subscribe>
Sender: fedora-list-bounces@redhat.com
Errors-To: fedora-list-bounces@redhat.com
To: linux-scsi@vger.kernel.org, fedora-list@redhat.com
Cc: Markus Lidel <Markus.Lidel@shadowconnect.com>
List-Id: linux-scsi@vger.kernel.org


>>>> I attempted to upgrade my RH9 (2.4.20-37.9) system to FC3 (2.6.9 I
>>>> believe is the release on the CDs).
>>>> I was able to get into Anaconda (by adding the I2O Block driver at the
>>>> "add Driver" screen) and to the section where I chose either a Fresh
>>>> install or an upgrade.
>>>> The first time I reached that point, the upgrade portion specified the
>>>> hdb (sdb) drive, which is my "backup" drive.  The drive I need to
>>>> upgrade is hda (sda).  I then power cycled the system and removed the
>>>> sdb drive to make sure nothing on that drive is touched.
>>>> I reached the same Fresh or Upgrade point, and this time the hda
>>>> (/dev/i2o/hda8) drive showed properly.  I chose upgrade, and this 
>>>> error
>>>> appears:
>>>> Error mounting device sda8 as /: No such file or directory
>>>
>>> Hmmm, think there is some problem with the partition naming...
>>> One 2.4.x kernel you most likely used the dpt_i2o module, but on 
>>> 2.6.x kernel the default is the i2o_block module... So the device 
>>> names change from /dev/sdaX to /dev/i2o/hdaX... I don't know for 
>>> sure, but probably in /etc/fstab there are device names instead of 
>>> labels. Something like:
>>> ...
>>> /dev/sda8                       /                  ext2   defaults  
>>> 1  0
>>> ...
>>> And because the device names change FC3 couldn't mount /dev/sda8
>>> anymore...
>>
>> The current fstab is:
>> /dev/sda8       /                       ext3    defaults        1 1
>> /dev/sda1       /boot                   ext3    defaults        1 2
>> /dev/sda7       /usr/local              ext3    defaults        1 2
>> /dev/sda2       /var/lib/mysql          ext3    defaults        1 2
>> /dev/sda5       /var/log/httpd         ext3    defaults        1 2
>> /dev/sda6       /var/www                ext3    defaults        1 2
>> /dev/sda3               swap                    swap    
>> defaults       0 0
>
>
> OK...
>
>> Since I was not successful on the install, I did not add/change the
>> /dev/sda# to /dev/i2o/hda#.  (Device names do change from /dev/sdL# in
>> RH to /dev/i2o/hdL# in FC3+.)
>
>
> The problem with changing /etc/fstab is, if the upgrade doesn't work 
> for some reason you won't be able to boot into the "old" system 
> without changing it back...
>
> But i would guess that it will work, if you change it before upgrading...
>
>> In my pay job I am don't have the ability to use LABEL on a 
>> partition. Are you thinking I may be able to change the /dev/sda# to 
>> LABEL and
>> install that way?  Since the Fresh and the Upgrade install "found" the
>
>
> After the upgrade you have to be carefull with labels, because if you 
> also load i2o_scsi you could access each disk of the RAID array. In 
> case of RAID-1 you finally have 3 disks with the same label, which 
> could break your whole system...
>
>> drive successfully, I wouldn't think that Anaconda reads the fstab. 
>> (I'm not familiar with Anaconda, so my logic could be wrong.)
>
>
> Hmmm, i couldn't say for sure, but the /dev/sda8 must come from 
> somewhere... Are you sure that the "dpt_i2o" and "i2o_scsi" module is 
> not loaded? Because both would provide access to /dev/sda8...

Do I determine this during the upgrade by going to Alt-F2 (I think it 
is) and doing a lsmod?  And, if they are loaded, should I modprobe one 
or both out?

Are there different SCSI RAID that are better supported than the ZCR?  
If so, which ones?


>>>> Press OK to reboot your system.
>>>> The only action at this point is to push the "OK" button for the 
>>>> reboot.
>>>> I select "OK" and reboot to get back to the Fresh or Upgrade point, 
>>>> and
>>>> chose Fresh this time.  I did verify that the partitions shown are
>>>> hda{1-8}, with all sizes correct but no mount points specified.
>>>> I did not go any further.
>>>> The system has a 2010S ZCR Adaptec card with 2x36G RAID1 config, and a
>>>> 36G standalone drive (so three cards).  It is a SuperMicro 6023P-8R 
>>>> with
>>>> 2x2.4G Xeon and 1G RAM.
>>>> Since FC3 disk has 2.6.9, I didn't put the i2o_block into the CD's
>>>> because the i2o webpage shows that it is already in the 2.6.8.  (I do
>>>> see that some people have posted on the i2o website that they have had
>>>> successful installs.)
>>>> Currently the system is up with RH9 still on it.  I'd like to get FC3+
>>>> installed, but I can't seem to figure out what piece I am missing.
>>>> Any one give me some pointers?  Are there any alternatives to getting
>>>> FC3+ installed?  Unfortunately, don't look for immediate trial, as 
>>>> this
>>>> system is the only one I have.  I don't have a test system with the 
>>>> same
>>>> config.  Why?!, that'd be too easy!  :)
>>>
>>>
>>> Could you verify if this is true?
>>
> This most likely means this partition has not been formatted.


-- 
fedora-list mailing list
fedora-list@redhat.com
To unsubscribe: http://www.redhat.com/mailman/listinfo/fedora-list
