From: Brian King <brking@us.ibm.com>
Subject: Re: Symbios PCI error recovery [Was: Re: [PATCH/RFC] ppc64: EEH +
 SCSI recovery (IPR only)]
Date: Fri, 01 Apr 2005 09:27:22 -0600
Message-ID: <424D685A.6070505@us.ibm.com>
References: <20050223002409.GA10909@austin.ibm.com>	<20050223174356.GH13081@kroah.com>	<1109207532.5384.32.camel@gaston>	<20050224013137.GF2088@austin.ibm.com>	<20050226063609.GC7036@colo.lackof.org>	<20050321231028.GV498@austin.ibm.com>	<20050322175728.GE12675@colo.lackof.org>	<20050331200622.GG15596@austin.ibm.com>
	<20050401060834.GB29734@colo.lackof.org>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc64-dev-bounces@ozlabs.org>
In-Reply-To: <20050401060834.GB29734@colo.lackof.org>
List-Unsubscribe: <https://ozlabs.org/cgi-bin/mailman/listinfo/linuxppc64-dev>,
	<mailto:linuxppc64-dev-request@ozlabs.org?subject=unsubscribe>
List-Archive: <http://ozlabs.org/pipermail/linuxppc64-dev>
List-Post: <mailto:linuxppc64-dev@ozlabs.org>
List-Help: <mailto:linuxppc64-dev-request@ozlabs.org?subject=help>
List-Subscribe: <https://ozlabs.org/cgi-bin/mailman/listinfo/linuxppc64-dev>,
	<mailto:linuxppc64-dev-request@ozlabs.org?subject=subscribe>
Sender: linuxppc64-dev-bounces@ozlabs.org
Errors-To: linuxppc64-dev-bounces@ozlabs.org
To: Grant Grundler <grundler@parisc-linux.org>
Cc: linuxppc64-dev@ozlabs.org, linux-scsi@vger.kernel.org, matthew@wil.cx
List-Id: linux-scsi@vger.kernel.org

Grant Grundler wrote:
>>>You want everything moved back to the "queued" state or failed
>>>(flush pending IO so upper layers can retry if they want).
>>
>>Upper layer is the linux block device; my understanding is that it does
>>not retry, nor do the filesystems above that.  Passing errors upwards
>>seems to be pretty darned fatal.  My goal is to limit retries to the
>>driver.
> 
> 
> That's a bad idea. Been there done that.
> 
> Upper layers can be alot smarter about retries than the driver ever
> could be. While the driver knows more about the transport and why
> someting might fail, upper layers will know alternate pathes 
> to the same devices or to the same data on different devices.
> Upper layers also set the recovery policy for particular storage.
> 
> Trying to do recovery transperently in the drivers is going to also
> mess up other high level SW like Service Guard or LifeKeeper.
> They want to know when a path has failed, log it, and make sure
> someone gets sent to service the HW if threshholds are exceeded.
> 
> Let higher layers like dm, VxFS, LVM worry about recovery.

The sym2 driver should fail everything back with DID_ERROR.
In most cases, the scsi midlayer will retry if the upper layer allows
retries and you will get the behavior you desire. If retries are not
allowed, like for a tape device, the command will get failed back to the
upper layer driver.

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
