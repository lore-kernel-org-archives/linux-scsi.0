From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: Re: [PATCH 5/6] qla4xxx: Capture minidump for ISP82XX on firmware
 failure
Date: Fri, 18 May 2012 02:29:39 -0700
Message-ID: <CBDC0F1D.ED30%vikas.chaudhary@qlogic.com>
References: <1337245969.30498.4.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:52285
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932852Ab2ERJ3r convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 May 2012 05:29:47 -0400
In-Reply-To: <1337245969.30498.4.camel@dabdike.int.hansenpartnership.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Tej Parkash <tej.parkash@qlogic.com>, Shyam Sundar <shyam.sundar@qlogic.com>



-----Original Message-----
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Admin <vikas.chaudhary@qlogic.com>, scsi <linux-scsi@vger.kernel.org>,
Lalit Chandivade <lalit.chandivade@qlogic.com>, Ravi Anand
<ravi.anand@qlogic.com>, Tej Parkash <tej.parkash@qlogic.com>, Shyam
Sundar <shyam.sundar@qlogic.com>
Subject: Re: [PATCH 5/6] qla4xxx: Capture minidump for ISP82XX on firmware
failure

>On Fri, 2012-04-27 at 11:05 -0500, Mike Christie wrote:
>> On 04/24/2012 12:32 AM, vikas.chaudhary@qlogic.com wrote:
>> > +
>> > +static ssize_t
>> > +qla4_8xxx_sysfs_write_fw_dump(struct file *filep, struct kobject
>>*kobj,
>> > +                        struct bin_attribute *ba, char *buf, loff_t off,
>> > +                        size_t count)
>> > +{
>> > +  struct scsi_qla_host *ha =
>>to_qla_host(dev_to_shost(container_of(kobj,
>> > +                                         struct device, kobj)));
>> > +  uint32_t dev_state;
>> > +  int reading;
>> > +
>> > +  if (!is_qla8022(ha))
>> > +          return -EINVAL;
>> > +
>> > +  if (off != 0)
>> > +          return 0;
>> > +
>> > +  reading = simple_strtol(buf, NULL, 10);
>>
>> I think we are supposed to be using kstrtol now.
>
>We are.  Checkpatch even warns about this, please fix.

We have posted updated patch to scsi-list here:-
http://marc.info/?l=linux-scsi&m=133733192809849&w=2

In 1st version of patch we used simple_strtol() as sysfs attribute buffer
is not NULL terminated string and
it include some garbage characters because of this kstrtol() fails.

If I write "5" to sysfs attribute I am getting following string in buf:-

-------------------------------------------
May 18 12:07:54 magana kernel: buf: 5
May 18 12:07:54 magana kernel: ter-|   Receive
                   |  Transmit
May 18 12:07:54 magana kernel: face |bytes    packets errs drop fifo frame
compressed multicast|bytes    packets errs drop fifo colls carrier
compressed
May 18 12:07:54 magana kernel:  eth2:  520166    5418    0    0    0     0
         0       325   393879    1978    0    0    0     0       0
 0
May 18 12:07:54 magana kernel:  eth3:       0       0    0    0    0     0
         0         0        0       0    0    0    0     0       0
 0
May 18 12:07:54 magana kernel:  eth4: 1398425   18696    0    0    0     0
         0         0     7631      39    0    0    0     0       0
 0
May 18 12:07:54 magana kernel:  eth5: 1394451   18678    0    0    0     0
         0         0     6427      30    0    0    0     0       0
 0
May 18 12:07:54 magana kernel:    lo:  361420    1082    0    0    0     0
         0         0   361420    1082    0    0    0     0       0
 0
May 18 12:07:54 magana kernel: virbr0-nic:       0       0    0    0    0
   0          0         0        0       0    0    0    0     0       0
      0
May 18 12:07:54 magana kernel: virbr0:       0       0    0    0    0
0          0         0        0
-------------------------------------------

As we are getting garbage characters after "5", kstrtol() fails but
simple_strtol() works well.

I posted email for same to scsi-list here:-
http://marc.info/?l=linux-scsi&m=133612575603304&w=2

For now in updated patch I am writing "0" at sysfs attribute buf[1] as we
are interested only in buf[0] and after this change kstrtol() works well.

I am interested to know if the behavior of sysfs attribute is correct or
is it an issue?




This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

