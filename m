From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [RFC] sg3_utils: sgp_dd: work around on pthread_cancel for
 android
Date: Fri, 22 Dec 2017 19:43:38 -0500
Message-ID: <b5e85d2f-e7d6-517b-a9b1-7fa482d5c5f0@interlog.com>
References: <e5c8b6616ea7487d83087da7623576ae@SIWEX5A.sing.micron.com>
 <1513967090.2579.13.camel@sandisk.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:47488 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757092AbdLWAno (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Dec 2017 19:43:44 -0500
In-Reply-To: <1513967090.2579.13.camel@sandisk.com>
Content-Language: en-CA
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "beanhuo@micron.com" <beanhuo@micron.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "hare@suse.de" <hare@suse.de>

On 2017-12-22 01:24 PM, Bart Van Assche wrote:
> On Fri, 2017-12-22 at 17:00 +0000, Bean Huo (beanhuo) wrote:
>>   case "${host}" in
>> +        *-*-android*)
>> +		AC_DEFINE_UNQUOTED(SG_ON_ANDROID, 1, [sg3_utils on android])
>> +		AC_DEFINE_UNQUOTED(SG_LIB_LINUX, 1, [sg3_utils on linux])
>> +                AC_SUBST([os_cflags], [''])
>> +                AC_SUBST([os_libs], ['']) ;;
>>           *-*-linux-gnu*)
>>   		AC_DEFINE_UNQUOTED(SG_LIB_LINUX, 1, [sg3_utils on linux])
>>                   AC_SUBST([os_cflags], [''])
>> @@ -79,6 +84,7 @@ AM_CONDITIONAL(OS_OSF, [echo $host_os | grep '^osf' > /dev/null])
>>   AM_CONDITIONAL(OS_SOLARIS, [echo $host_os | grep '^solaris' > /dev/null])
>>   AM_CONDITIONAL(OS_WIN32_MINGW, [echo $host_os | grep '^mingw' > /dev/null])
>>   AM_CONDITIONAL(OS_WIN32_CYGWIN, [echo $host_os | grep '^cygwin' > /dev/null])
>> +AM_CONDITIONAL(OS_ANDROID, [echo $host_os | grep 'android' > /dev/null])
> 
> Hello Bean,
> 
> Please consider to use AC_CHECK_FUNC([pthread_cancel]) or similar to check the
> availability of pthread_cancel(). Explicit distro checks are much harder to maintain
> than checks for individual functions.

That macro doesn't work in Linux. It doesn't work in the sense that
Linux (Ubuntu 17.10) does have pthread_cancel but needs -lpthread
in the link. So AC_CHECK_FUNC([pthread_cancel]) does not place
'#define HAVE_PTHREAD_CANCEL 1' in config.h .

This seems to work in Linux but may not work in Android:
AC_SEARCH_LIBS([pthread_cancel], [pthread], [AC_DEFINE(HAVE_PTHREAD_CANCEL, 1, 
[Found pthread_cancel])], [])

Bean, could you check?

Anyway, I like having an OS type for Android (which I have renamed from
Bean's patch to SG_LIB_ANDROID to be consistent with my other OS
naming). Overall the patch works in Linux.

Doug Gilbert
