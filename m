From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Add ACCUSYS RAID driver for Linux i386/x86-64
Date: Wed, 24 Oct 2007 00:08:32 -0700
Message-ID: <20071024000832.af31fc90.akpm@linux-foundation.org>
References: <cbc61c0d0710220317w68f4f119xceb10192f2ad0158@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53442 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750784AbXJXHIn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Oct 2007 03:08:43 -0400
In-Reply-To: <cbc61c0d0710220317w68f4f119xceb10192f2ad0158@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Peter Chan <accusys.sw5@gmail.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jeffchang@accusys.com.tw, ythuang@accusys.com.tw

On Mon, 22 Oct 2007 18:17:49 +0800 "Peter Chan" <accusys.sw5@gmail.com> wrote:

> Dear Morton
> 
> Thanks for your doing.
> We modified source code as your requested. If you have any comment please
> let me know.
> Do you need RAID HBA to test at this stage? If "yes", Which address can i
> ship RAID HBA for you?

Please, you really will need to become a bit more familiar with the way we
work.  As far as I know, nobody in the linux world uses RAR format - that's
a windows thing.  I doubt if anyone except I has actually gone to the
effort to decrypt that attachment.

Start with

Documentation/SubmittingPatches
Documentation/SubmittingDrivers
Documentation/SubmitChecklist
http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt
http://linux.yyz.us/patch-format.html

There are a number of remaining stylistic things which we can look at more
closely when we have patches which are in a usable form.

- Linux doesn't use capitalisation in variable names.  Use "tail", not "Tail"

- Linux uses underscored to separate words.  Use "reply_frame", not
  "replyframe" or "ReplyFrame".

- We don't like to see code which has any dependency on
  LINUX_VERSION_CODE or KENREL_VERSION: the code in Linux is suppsoed to
  work correctly in the version of the kernel which it s found and that's
  it.

- I don't know what this:

+#if defined(CONFIG_MODVERSIONS) && !defined(MODVERSIONS)
+       #define MODVERSIONS
+#endif

  is doing, but it's probably wrong.

- Use request_node, not RequestNode, etc.

- Don't parenthesise the argument to `return'.

- I see at least one U32 in there.  Please use u32. (Does U32 even work?)

- This:

+static int acs_ame_get_log(
+		struct Acs_Adapter *acs_adt,
+		struct EventLog *event_log)

  isn't preferred style.  Use


static int acs_ame_get_log(struct Acs_Adapter *acs_adt,
				struct EventLog *event_log)

  or, if you particularly dislike that, blow the 80-col rule and do

static int acs_ame_get_log(struct Acs_Adapter *acs_adt, struct EventLog *event_log)

- This

+       writel((replyframe), base_addr+AME_REPLY_MSG_PORT);

  is overparenthesised.

- Beware that the scatter/gather APIs just got significantly changed. 
  You code might need adjustment to work against the latest mainline tree.

- What does CHAR_DEV do?  Probably it should be a Kconfig CONFIG_* option.

- All the code around acs_ame_schedule_command() (which is incorrectly
  identified as arcmsr_schedule_command in its comment block) is indented a
  tab stop.  That's really weird.  Please make it normal.

- acs_ame_schedule_command() has an up-to-sixty-second busywait.  Bad. 
  Can we get a sleep+wakeup in there?

- This:

+	    struct
+	    {
+		unsigned int   vendor_id;
+		unsigned int   device_id;
+	    } const	acs_ame_devices[] = {
+		{ 0x14D6, DEVICEID_ACS_61000_XX }
+		, { 0x14D6, DEVICEID_ACS_62000_08 }
+		, { 0x1AB6, DEVICEID_ACS_61000_XX }
+		, { 0x1AB6, DEVICEID_ACS_62000_08 }
+	    };

 should be

	static const struct {
		unsigned int   vendor_id;
		unsigned int   device_id;
	} acs_ame_devices[] = {
		{ 0x14D6, DEVICEID_ACS_61000_XX },
		{ 0x14D6, DEVICEID_ACS_62000_08 },
		{ 0x1AB6, DEVICEID_ACS_61000_XX },
		{ 0x1AB6, DEVICEID_ACS_62000_08 },
	};

  which has many changes from the original.

  I'd have thought that the kernel already has a data type for this, but
  I can't find it.  Most drivers just rely upon the normal PCI device ID
  tables.  It is suspicious that this one doesn't.


Anyway, that's just from a quick scan.  There are a huge number of similar
issues in there.  Please take some time to study some well-maintained Linux
driver code and the interfaces which scsi and PCI drivers use and try to
make this driver a lot more Linux-like, thanks.



