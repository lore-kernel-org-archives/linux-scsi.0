From: "Seymour, Shane M" <shane.seymour@hp.com>
Subject: RE: [scsi:misc 114/120] drivers/scsi/st.c:4594:3: warning: format
 '%ld' expects argument of type 'long int', but argument 3 has type 'long
 long int'
Date: Mon, 1 Jun 2015 02:53:05 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB3BFC1230@G4W3219.americas.hpqcorp.net>
References: <201506011003.3GKnCoBM%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:7493 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbbFACxg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 31 May 2015 22:53:36 -0400
In-Reply-To: <201506011003.3GKnCoBM%fengguang.wu@intel.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Cc: "kbuild-all@01.org" <kbuild-all@01.org>, James Bottomley <JBottomley@Odin.com>, Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

My apologies for this I'm fixing it now.

-----Original Message-----
From: kbuild test robot [mailto:fengguang.wu@intel.com] 
Sent: Monday, June 01, 2015 12:36 PM
To: Seymour, Shane M
Cc: kbuild-all@01.org; James Bottomley; Christoph Hellwig; linux-scsi@vger.kernel.org
Subject: [scsi:misc 114/120] drivers/scsi/st.c:4594:3: warning: format '%ld' expects argument of type 'long int', but argument 3 has type 'long long int'

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git misc
head:   f6e08d7c118cc44f10bffdf52a31d7f40ce86ba7
commit: fc5280a80c124fe2d8b661513670a574fcd8bcbc [114/120] st: implement tape statistics
config: i386-allyesconfig (attached as .config)
reproduce:
  git checkout fc5280a80c124fe2d8b661513670a574fcd8bcbc
  # save the attached .config to linux build tree
  make ARCH=i386 

All warnings:

   drivers/scsi/st.c: In function 'read_cnt_show':
>> drivers/scsi/st.c:4594:3: warning: format '%ld' expects argument of type 'long int', but argument 3 has type 'long long int' [-Wformat=]
      atomic64_read(&STm->tape->stats->read_cnt));
      ^
   drivers/scsi/st.c: In function 'read_byte_cnt_show':
>> drivers/scsi/st.c:4612:3: warning: format '%ld' expects argument of type 'long int', but argument 3 has type 'long long int' [-Wformat=]
      atomic64_read(&STm->tape->stats->read_byte_cnt));
      ^
   drivers/scsi/st.c: In function 'read_ns_show':
>> drivers/scsi/st.c:4628:3: warning: format '%ld' expects argument of type 'long int', but argument 3 has type 'long long int' [-Wformat=]
      atomic64_read(&STm->tape->stats->tot_read_time));
      ^
   drivers/scsi/st.c: In function 'write_cnt_show':
>> drivers/scsi/st.c:4645:3: warning: format '%ld' expects argument of type 'long int', but argument 3 has type 'long long int' [-Wformat=]
      atomic64_read(&STm->tape->stats->write_cnt));
      ^
   drivers/scsi/st.c: In function 'write_byte_cnt_show':
>> drivers/scsi/st.c:4662:3: warning: format '%ld' expects argument of type 'long int', but argument 3 has type 'long long int' [-Wformat=]
      atomic64_read(&STm->tape->stats->write_byte_cnt));
      ^
   drivers/scsi/st.c: In function 'write_ns_show':
>> drivers/scsi/st.c:4679:3: warning: format '%ld' expects argument of type 'long int', but argument 3 has type 'long long int' [-Wformat=]
      atomic64_read(&STm->tape->stats->tot_write_time));
      ^
   drivers/scsi/st.c: In function 'in_flight_show':
>> drivers/scsi/st.c:4697:3: warning: format '%ld' expects argument of type 'long int', but argument 3 has type 'long long int' [-Wformat=]
      atomic64_read(&STm->tape->stats->in_flight));
      ^
   drivers/scsi/st.c: In function 'io_ns_show':
>> drivers/scsi/st.c:4717:3: warning: format '%ld' expects argument of type 'long int', but argument 3 has type 'long long int' [-Wformat=]
      atomic64_read(&STm->tape->stats->tot_io_time));
      ^
   drivers/scsi/st.c: In function 'other_cnt_show':
>> drivers/scsi/st.c:4736:3: warning: format '%ld' expects argument of type 'long int', but argument 3 has type 'long long int' [-Wformat=]
      atomic64_read(&STm->tape->stats->other_cnt));
      ^
   drivers/scsi/st.c: In function 'resid_cnt_show':
>> drivers/scsi/st.c:4754:3: warning: format '%ld' expects argument of type 'long int', but argument 3 has type 'long long int' [-Wformat=]
      atomic64_read(&STm->tape->stats->resid_cnt));
      ^

vim +4594 drivers/scsi/st.c

  4588	static ssize_t read_cnt_show(struct device *dev,
  4589		struct device_attribute *attr, char *buf)
  4590	{
  4591		struct st_modedef *STm = dev_get_drvdata(dev);
  4592	
  4593		return sprintf(buf, "%ld",
> 4594			atomic64_read(&STm->tape->stats->read_cnt));
  4595	}
  4596	static DEVICE_ATTR_RO(read_cnt);
  4597	
  4598	/**
  4599	 * read_byte_cnt_show - return read byte count - tape drives
  4600	 * may use blocks less than 512 bytes this gives the raw byte count of
  4601	 * of data read from the tape drive.
  4602	 * @dev: struct device
  4603	 * @attr: attribute structure
  4604	 * @buf: buffer to return formatted data in
  4605	 */
  4606	static ssize_t read_byte_cnt_show(struct device *dev,
  4607		struct device_attribute *attr, char *buf)
  4608	{
  4609		struct st_modedef *STm = dev_get_drvdata(dev);
  4610	
  4611		return sprintf(buf, "%ld",
> 4612			atomic64_read(&STm->tape->stats->read_byte_cnt));
  4613	}
  4614	static DEVICE_ATTR_RO(read_byte_cnt);
  4615	
  4616	/**
  4617	 * read_us_show - return read us - overall time spent waiting on reads in ns.
  4618	 * @dev: struct device
  4619	 * @attr: attribute structure
  4620	 * @buf: buffer to return formatted data in
  4621	 */
  4622	static ssize_t read_ns_show(struct device *dev,
  4623		struct device_attribute *attr, char *buf)
  4624	{
  4625		struct st_modedef *STm = dev_get_drvdata(dev);
  4626	
  4627		return sprintf(buf, "%ld",
> 4628			atomic64_read(&STm->tape->stats->tot_read_time));
  4629	}
  4630	static DEVICE_ATTR_RO(read_ns);
  4631	
  4632	/**
  4633	 * write_cnt_show - write count - number of user calls
  4634	 * to write(2) that have written data to tape.
  4635	 * @dev: struct device
  4636	 * @attr: attribute structure
  4637	 * @buf: buffer to return formatted data in
  4638	 */
  4639	static ssize_t write_cnt_show(struct device *dev,
  4640		struct device_attribute *attr, char *buf)
  4641	{
  4642		struct st_modedef *STm = dev_get_drvdata(dev);
  4643	
  4644		return sprintf(buf, "%ld",
> 4645			atomic64_read(&STm->tape->stats->write_cnt));
  4646	}
  4647	static DEVICE_ATTR_RO(write_cnt);
  4648	
  4649	/**
  4650	 * write_byte_cnt_show - write byte count - raw count of
  4651	 * bytes written to tape.
  4652	 * @dev: struct device
  4653	 * @attr: attribute structure
  4654	 * @buf: buffer to return formatted data in
  4655	 */
  4656	static ssize_t write_byte_cnt_show(struct device *dev,
  4657		struct device_attribute *attr, char *buf)
  4658	{
  4659		struct st_modedef *STm = dev_get_drvdata(dev);
  4660	
  4661		return sprintf(buf, "%ld",
> 4662			atomic64_read(&STm->tape->stats->write_byte_cnt));
  4663	}
  4664	static DEVICE_ATTR_RO(write_byte_cnt);
  4665	
  4666	/**
  4667	 * write_ns_show - write ns - number of nanoseconds waiting on write
  4668	 * requests to complete.
  4669	 * @dev: struct device
  4670	 * @attr: attribute structure
  4671	 * @buf: buffer to return formatted data in
  4672	 */
  4673	static ssize_t write_ns_show(struct device *dev,
  4674		struct device_attribute *attr, char *buf)
  4675	{
  4676		struct st_modedef *STm = dev_get_drvdata(dev);
  4677	
  4678		return sprintf(buf, "%ld",
> 4679			atomic64_read(&STm->tape->stats->tot_write_time));
  4680	}
  4681	static DEVICE_ATTR_RO(write_ns);
  4682	
  4683	/**
  4684	 * in_flight_show - number of I/Os currently in flight -
  4685	 * in most cases this will be either 0 or 1. It may be higher if someone
  4686	 * has also issued other SCSI commands such as via an ioctl.
  4687	 * @dev: struct device
  4688	 * @attr: attribute structure
  4689	 * @buf: buffer to return formatted data in
  4690	 */
  4691	static ssize_t in_flight_show(struct device *dev,
  4692		struct device_attribute *attr, char *buf)
  4693	{
  4694		struct st_modedef *STm = dev_get_drvdata(dev);
  4695	
  4696		return sprintf(buf, "%ld",
> 4697			atomic64_read(&STm->tape->stats->in_flight));
  4698	}
  4699	static DEVICE_ATTR_RO(in_flight);
  4700	
  4701	/**
  4702	 * io_ns_show - io wait ns - this is the number of ns spent
  4703	 * waiting on all I/O to complete. This includes tape movement commands
  4704	 * such as rewinding, seeking to end of file or tape, it also includes
  4705	 * read and write. To determine the time spent on tape movement
  4706	 * subtract the read and write ns from this value.
  4707	 * @dev: struct device
  4708	 * @attr: attribute structure
  4709	 * @buf: buffer to return formatted data in
  4710	 */
  4711	static ssize_t io_ns_show(struct device *dev,
  4712		struct device_attribute *attr, char *buf)
  4713	{
  4714		struct st_modedef *STm = dev_get_drvdata(dev);
  4715	
  4716		return sprintf(buf, "%ld",
> 4717			atomic64_read(&STm->tape->stats->tot_io_time));
  4718	}
  4719	static DEVICE_ATTR_RO(io_ns);
  4720	
  4721	/**
  4722	 * other_cnt_show - other io count - this is the number of
  4723	 * I/O requests other than read and write requests.
  4724	 * Typically these are tape movement requests but will include driver
  4725	 * tape movement. This includes only requests issued by the st driver.
  4726	 * @dev: struct device
  4727	 * @attr: attribute structure
  4728	 * @buf: buffer to return formatted data in
  4729	 */
  4730	static ssize_t other_cnt_show(struct device *dev,
  4731		struct device_attribute *attr, char *buf)
  4732	{
  4733		struct st_modedef *STm = dev_get_drvdata(dev);
  4734	
  4735		return sprintf(buf, "%ld",
> 4736			atomic64_read(&STm->tape->stats->other_cnt));
  4737	}
  4738	static DEVICE_ATTR_RO(other_cnt);
  4739	
  4740	/**
  4741	 * resid_cnt_show - A count of the number of times we get a residual
  4742	 * count - this should indicate someone issuing reads larger than the
  4743	 * block size on tape.
  4744	 * @dev: struct device
  4745	 * @attr: attribute structure
  4746	 * @buf: buffer to return formatted data in
  4747	 */
  4748	static ssize_t resid_cnt_show(struct device *dev,
  4749		struct device_attribute *attr, char *buf)
  4750	{
  4751		struct st_modedef *STm = dev_get_drvdata(dev);
  4752	
  4753		return sprintf(buf, "%ld",
> 4754			atomic64_read(&STm->tape->stats->resid_cnt));
  4755	}
  4756	static DEVICE_ATTR_RO(resid_cnt);
  4757	

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
