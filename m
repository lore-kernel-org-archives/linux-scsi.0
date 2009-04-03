From: "Love, Robert W" <robert.w.love@intel.com>
Subject: RE: [PATCH 00/15] Open-FCoE updates (fixes and a feature) for
	2.6.30 merge window
Date: Fri, 3 Apr 2009 15:28:33 -0700
Message-ID: <273D38FBE7C6FE46A1689FCD014A0B8B4164F144@azsmsx505.amr.corp.intel.com>
References: <20090403215758.10856.6946.stgit@fritz>
 <1238796840.3359.95.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:17929 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309AbZDCW2i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Apr 2009 18:28:38 -0400
In-Reply-To: <1238796840.3359.95.camel@mulgrave.int.hansenpartnership.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Fri, 2009-04-03 at 14:57 -0700, Robert Love wrote:
>> The following series implements some bug fixes to libfc
>> and the addition of dynamic logging capabilities for libfc,
>> libfcoe and fcoe.
> 
> Realistically, this is pretty much too late for 2.6.30.  It needs at
> least a cursory review and incubation in linux-next (which doesn't
> build over the weekend anyway) which can't happen before Linus
> declares -rc1 estimated to be on Tuesday.
> 
OK, I wasn't sure about your deadlines. Abhijeet's fixes should be
fine for the early 30 RC phase since they're fixes.

The debug_logging stuff is a nice-to-have not must-have feature.
I can keep the set up to date through the early 30 RC phase and
when you're ready to put stuff into scsi-misc for 31 I'd like to
get it in early since it touches so many lines of code and is a
pain to keep current.

>> The bug fixes are mostly related to the rogue rport
>> tracking that libfc does before getting a "real"
>> rport from the FC transport. Also there are locking
>> and state verification fixes.
>> 
>> The dynamic logging code was originally mailed to
>> linux-scsi during the 2.6.29 rc phase, but was
>> incorrectly mixed in with fixes. This is a refresh
>> of that patch set. Since that original patch set
>> libfcoe and fcoe have been better distinguished as
>> separate modules, so this patch set was modified to
>> reflect that change.
>> 
>> ---
>> 
>> Abhijeet Joglekar (6):
>>       libfc: whenever queueing delete ev for rport, set state to NONE
>>       libfc: Change state to NONE in fc_lport_destroy
>>       libfc: During fabric logoff, flush the rport Q after logging
>>       off dns port libfc: Track rogue remote ports
>>       libfc: Do not retry if the new state is not the same as old
>>       state libfc: Hold disc mutex while processing gpn ft resp
>> 
>> Robert Love (9):
>>       libfc: Remove unused FC_DBG macro
>>       libfc: Convert debug statements in fc_exch.c to use new libfc
>>       debug macros. libfc: Convert debug statements in fc_fcp.c to
>>       use new libfc debug macros. libfc: Convert debug statements in
>>       fc_rport.c to use new libfc debug macros. libfc: Convert debug
>>       statements in fc_disc.c to use new libfc debug macros. libfc:
>>       Convert debug statements in fc_lport.c to use new libfc debug
>>       macros. libfc: Add runtime debugging with debug_logging module
>>       parameter libfcoe: Add runtime debugging with module param
>> debug_logging fcoe: Add runtime debug logging with module parameter
>> debug_logging  
> 
> Couldn't these just have been a single patch?  Or one patch for the
> macro conversion and one for the module parameters.  There's no need
> at all to do one patch per file when converting.
> 
Yeah, they could have been consolidated, I just thought it would be
nicer for review since it breaks the patch up a bit. BTW: each of the
files represents a sub-component within libfc, so they are logically
divided, not only broken out by file name. It just happens that each
of our sub components only has one file.

> James

